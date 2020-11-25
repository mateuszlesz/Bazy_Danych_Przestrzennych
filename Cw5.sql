create extension postgis_raster;
Zad 1
raster2pgsql -s 3763 -N -32767 -t 100x100 -I -C -M -d C:\Users\mateu\Desktop\bazy\rasters\srtm_1arc_v3.tif rasters.dem > C:\Users\mateu\Desktop\bazy\rasters\dem.sql
Zad 2.
raster2pgsql -s 3763 -N -32767 -t 100x100 -I -C -M -d C:\Users\mateu\Desktop\bazy\rasters\srtm_1arc_v3.tif rasters.dem | psql -d Zad6 -h localhost -U postgres -p 5432
Zad 3.
raster2pgsql.exe -s 3763 -N -32767 -t 128x128 -I -C -M -d C:\Users\mateu\Desktop\bazy\rasters\Landsat8_L1TP_RGBN.TIF rasters.landsat8 | psql -d Zad6 -h localhost -U postgres -p 5432
Zad 4.
CREATE TABLE leszczynski.intersects AS
SELECT a.rast, b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto';
-1
alter table leszczynski.intersects
add column rid SERIAL PRIMARY KEY;
-2
CREATE INDEX idx_intersects_rast_gist ON leszczynski.intersects
USING gist (ST_ConvexHull(rast));
-3
SELECT AddRasterConstraints('leszczynski'::name, 'intersects'::name,'rast'::name);
Zad 5

CREATE TABLE leszczynski.clip AS
SELECT ST_Clip(a.rast, b.geom, true), b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality like 'PORTO';

Zad 6

CREATE TABLE leszczynski.union AS
SELECT ST_Union(ST_Clip(a.rast, b.geom, true))
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast);
Zad 7

CREATE TABLE leszczynski.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

 Zad 8
 
DROP TABLE leszczynski.porto_parishes; --> drop table porto_parishes first
CREATE TABLE leszczynski.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

Zad 9

DROP TABLE leszczynski.porto_parishes; --> drop table porto_parishes first
CREATE TABLE leszczynski.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1 )
SELECT st_tile(st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)),128,128,true,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

Zad 10

create table leszczynski.intersection as
SELECT a.rid,(ST_Intersection(b.geom,a.rast)).geom,(ST_Intersection(b.geom,a.rast)).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);
 
 Zad 11
CREATE TABLE leszczynski.dumppolygons AS
SELECT a.rid,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).geom,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);
Zad 12
CREATE TABLE leszczynski.landsat_nir AS
SELECT rid, ST_Band(rast,4) AS rast
FROM rasters.landsat8;
Zad 13
CREATE TABLE leszczynski.paranhos_dem AS
SELECT a.rid,ST_Clip(a.rast, b.geom,true) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);
Zad 14 
CREATE TABLE leszczynski.paranhos_slope AS
SELECT a.rid,ST_Slope(a.rast,1,'32BF','PERCENTAGE') as rast
FROM leszczynski.paranhos_dem AS a;
Zad 15
CREATE TABLE leszczynski.paranhos_slope_reclass AS
SELECT a.rid,ST_Reclass(a.rast,1,']0-15]:1, (15-30]:2, (30-9999:3', '32BF',0)
FROM leszczynski.paranhos_slope AS a;
Zad 16
SELECT st_summarystats(a.rast) AS stats
FROM leszczynski.paranhos_dem AS a;
Zad 17
SELECT st_summarystats(ST_Union(a.rast))
FROM leszczynski.paranhos_dem AS a;
Zad 18
WITH t AS (
SELECT st_summarystats(ST_Union(a.rast)) AS stats
FROM leszczynski.paranhos_dem AS a
)
SELECT (stats).min,(stats).max,(stats).mean FROM t;
Zad 19
WITH t AS (
SELECT b.parish AS parish, st_summarystats(ST_Union(ST_Clip(a.rast, b.geom,true))) AS stats
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
group by b.parish
)
SELECT parish,(stats).min,(stats).max,(stats).mean FROM t;
Zad 20
SELECT b.name,st_value(a.rast,(ST_Dump(b.geom)).geom)
FROM
rasters.dem a, vectors.places AS b
WHERE ST_Intersects(a.rast,b.geom)
ORDER BY b.name;
Zad 21
create table leszczynski.tpi30 as
select ST_TPI(a.rast,1) as rast
from rasters.dem a;
Zad 22
CREATE INDEX idx_tpi30_rast_gist ON leszczynski.tpi30
USING gist (ST_ConvexHull(rast));
Przyklad do samodzielnego rozwiania
CREATE TABLE leszczynski.tpi30_porto as
SELECT ST_TPI(a.rast,1) as rast
FROM rasters.dem a, vectors.porto_parishes AS b WHERE  ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto'

CREATE INDEX idx_tpi30_porto_rast_gist ON leszczynski.tpi30_porto
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('leszczynski'::name, 'tpi30_porto'::name,'rast'::name);

Zad 23
CREATE TABLE leszczynski.porto_ndvi AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, 1,
r.rast, 4,
'([rast2.val] - [rast1.val]) / ([rast2.val] + [rast1.val])::float','32BF'
) AS rast
FROM r;

CREATE INDEX idx_porto_ndvi_rast_gist ON leszczynski.porto_ndvi
USING gist (ST_ConvexHull(rast));


SELECT AddRasterConstraints('leszczynski'::name, 'porto_ndvi'::name,'rast'::name);

Zad 24
create or replace function leszczynski.ndvi(
value double precision [] [] [],
pos integer [][],
VARIADIC userargs text []
)
RETURNS double precision AS
$$
BEGIN
--RAISE NOTICE 'Pixel Value: %', value [1][1][1];-->For debug purposes
RETURN (value [2][1][1] - value [1][1][1])/(value [2][1][1]+value [1][1][1]); --> NDVI calculation!
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE COST 1000;
Zad 25

CREATE TABLE leszczynski.porto_ndvi2 AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, ARRAY[1,4],
'leszczynski.ndvi(double precision[], integer[],text[])'::regprocedure, --> This is the function!
'32BF'::text
) AS rast
FROM r;

CREATE INDEX idx_porto_ndvi2_rast_gist ON leszczynski.porto_ndvi2
USING gist (ST_ConvexHull(rast));

SELECT AddRasterConstraints('leszczynski'::name, 'porto_ndvi2'::name,'rast'::name);
Zad 26
SELECT ST_AsTiff(ST_Union(rast))
FROM leszczynski.porto_ndvi;
Zad 27
SELECT ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
FROM leszczynski.porto_ndvi;
Zad 28
SELECT ST_GDALDrivers();

Zad 29
CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM leszczynski.porto_ndvi;
Zad 30
SELECT lo_export(loid, 'D:\myraster.tiff') --> Save the file in a place where the user postgres have access. In windows a flash drive usualy works fine.
FROM tmp_out;
Zad 31
SELECT lo_unlink(loid)
FROM tmp_out; --> Delete the large object.\
Zad 32
gdal_translate -co COMPRESS=DEFLATE -co PREDICTOR=2 -co ZLEVEL=9 PG:"host=localhost port=5432 dbname=Zad6 user=postgres password=123 schema=leszczynski table=porto_ndvi mode=2" porto_ndvi.tiff
Zad 33
MAP
NAME 'map'
SIZE 800 650
STATUS ON
EXTENT -58968 145487 30916 206234
UNITS METERS
WEB
METADATA
'wms_title' 'Terrain wms'
'wms_srs' 'EPSG:3763 EPSG:4326 EPSG:3857'
'wms_enable_request' '*'
'wms_onlineresource' 'http://54.37.13.53/mapservices/srtm'
END
END
PROJECTION
'init=epsg:3763'
END
LAYER
NAME srtm
TYPE raster
STATUS OFF
DATA "PG:host=localhost port=5432 dbname='Zad6' user='sasig' password='123' schema='rasters' table='dem' mode='2'"
PROCESSING "SCALE=AUTO"
PROCESSING "NODATA=-32767"
OFFSITE 0 0 0
METADATA
'wms_title' 'srtm'
END
END
END


