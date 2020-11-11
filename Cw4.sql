CREATE EXTENSION postgis

CREATE TABLE obiekty(id INT PRIMARY KEY UNIQUE,nazwa VARCHAR(15),geom GEOMETRY);

INSERT INTO obiekty VALUES(1,'obiekt1',ST_GeomFromText('COMPOUNDCURVE(LINESTRING(0 1,1 1),CIRCULARSTRING(1 1,2 0,3 1), CIRCULARSTRING(3 1,4 2,5 1), (5 1,6 1))',0)),
(2,'obiekt2',ST_GeomFromText('MultiCurve(CIRCULARSTRING(11 2,13 2,11 2),CompoundCurve(LINESTRING(10 6,14 6),CIRCULARSTRING(14 6,16 4,14 2),CIRCULARSTRING(14 2,12 0, 10 2), LINESTRING(10 2,10 6)))',0)),
(3,'obiekt3',ST_GeomFromText('POLYGON((7 15,10 17,12 13,7 15))',0)),
(4,'obiekt4',ST_GeomFromText('LINESTRING(20 20,25 25,27 24,25 22,26 21,22 19,20.5 19.5)',0)),
(5,'obiekt5',ST_GeomFromText('MULTIPOINT(30 30 59,38 32 234)',0)),
(6,'obiekt6',ST_GeomFromText('GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2), POINT(4 2))',0));

--1.
SELECT DISTINCT ST_AREA(ST_BUFFER(ST_SHORTESTLINE((SELECT geom FROM obiekty WHERE id=3),(SELECT geom FROM obiekty WHERE id=4)),5)) FROM obiekty
-- wynik 180.89525577144155

--2.
SELECT ST_MakePolygon (ST_AddPoint(foo.open_line, ST_StartPoint (foo.open_line))) 
FROM (SELECT geom AS open_line FROM obiekty WHERE id=4) AS foo;

--3.
INSERT INTO obiekty VALUES (7,'obiekt7',(SELECT DISTINCT ST_UNION((SELECT geom FROM obiekty WHERE id=3),(SELECT geom FROM obiekty WHERE id=4)) FROM obiekty))

--4.
SELECT SUM(ST_AREA(ST_BUFFER(obiekty.geom,5))) Pole_powierzchni FROM obiekty WHERE ST_HasArc(obiekty.geom) IS FALSE
--Wynik 954.664373202026


