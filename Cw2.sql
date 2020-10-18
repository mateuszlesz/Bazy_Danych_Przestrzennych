CREATE EXTENSION postgis;

CREATE TABLE budynki(id INT PRIMARY KEY UNIQUE,geometria GEOMETRY,nazwa VARCHAR(15));
CREATE TABLE drogi(id INT PRIMARY KEY UNIQUE,geometria GEOMETRY,nazwa VARCHAR(10));
CREATE TABLE punkty_informacyjne(id INT PRIMARY KEY UNIQUE,geometria GEOMETRY,nazwa VARCHAR(5));

INSERT INTO budynki VALUES (1,ST_GeomFromText('POLYGON((8 1.5,10.5 1.5,10.5 4,8 4,8 1.5))',0),'BuildingA'),
(2,ST_GeomFromText('POLYGON((4 7,4 5,6 5,6 7,4 7))',0),'BuildingB'),
(3,ST_GeomFromText('POLYGON((3 8,3 6,5 6,5 8,3 8))',0),'BuildingC'),
(4,ST_GeomFromText('POLYGON((9 9,9 8,10 8, 10 9,9 9))',0),'BuildingD'),
(5,ST_GeomFromText('POLYGON((1 2,1 1,2 1,2 2,1 2))',0),'BuildingF');

INSERT INTO drogi VALUES(1,ST_GeomFromText('LINESTRING(0 4.5,12 4.5)',0),'RoadX'),
(2,ST_GeomFromText('LINESTRING(7.5 0,7.5 10.5)',0),'RoadY');

INSERT INTO punkty_informacyjne VALUES(1,ST_GeomFromText('POINT(1 3.5)',0),'G'),
(2,ST_GeomFromText('POINT(5.5 1.5)',0),'H'),
(3,ST_GeomFromText('POINT(9.5 6)',0),'I'),
(4,ST_GeomFromText('POINT(6.5 6)',0),'J'),
(5,ST_GeomFromText('POINT(6 9.5)',0),'K');

SELECT *  from budynki;
SELECT *  from drogi;
SELECT *  from punkty_informacyjne;

SELECT SUM(ST_Length(geometria)) AS Całkowita_dlugość FROM drogi

SELECT ST_AsText(geometria) AS WKT , ST_Area(geometria) AS Pole_powierzchni, ST_Perimeter(geometria) AS Obwod
FROM budynki WHERE nazwa LIKE 'BuildingA'; 

SELECT nazwa, ST_Area(geometria) AS Pole_powierzchni FROM budynki ORDER BY nazwa ASC;

SELECT nazwa, ST_Area(geometria) AS Pole_powierzchni FROM budynki ORDER BY Pole_powierzchni DESC LIMIT 2;

SELECT ST_Distance(budynki.geometria,punkty_informacyjne.geometria) FROM budynki,punkty_informacyjne WHERE budynki.nazwa LIKE 'BuildingC' AND
punkty_informacyjne.nazwa LIKE 'G';

SELECT ST_Area(ST_Difference(budynki.geometria,(SELECT ST_Buffer(geometria,0.5) FROM budynki WHERE nazwa LIKE 'BuildingB')) )
FROM budynki WHERE nazwa LIKE 'BuildingC';

SELECT nazwa, ST_AsText(ST_Centroid(geometria)) AS centrum FROM budynki 
WHERE ST_Y(ST_Centroid(geometria)) > (SELECT ST_Y(ST_Centroid(geometria)) FROM drogi WHERE nazwa LIKE 'RoadX');

SELECT ST_AREA(ST_SymDifference(geometria,ST_GeomFromText('POLYGON((4 7,6 7,6 8,4 8,4 7))',0))) AS pole_powierzchni FROM budynki 
WHERE nazwa='BuildingC';



