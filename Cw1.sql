CREATE DATABASE s304178
CREATE SCHEMA firma
CREATE ROLE ksiegowosc
GRANT SELECT to ksiegowosc
GRANT SELECT on ALL Tables in Schema firma to ksiegowosc

CREATE TABLE firma.pracownicy(
id_pracownika varchar(5) Unique NOT NULL,
Imie varchar(20),
Nazwisko varchar(20),
Adres varchar(50),
Telefon varchar(12)
);
CREATE TABLE firma.godziny(
id_godziny varchar(5) Unique NOT NULL ,
Data DATE,
Liczba_godzin int,
id_pracownika varchar(5) not null 	
);

CREATE TABLE firma.pensja(
id_pensji varchar(5) Unique NOT NULL ,
stanowisko varchar(25),
kwota int
);

CREATE TABLE firma.premia(
id_premii varchar(5) unique,
rodzaj varchar(15),
kwota int
);

CREATE TABLE firma.wynagrodzenie(
id_wynagrodzenia varchar(5) unique NOT NULL ,
Data date,
id_pracownika varchar(5),
id_godziny varchar(5),
id_pensji varchar(5),
id_premii varchar(5) 
);


ALTER TABLE firma.pracownicy
ADD Primary Key (id_pracownika)
ALTER TABLE firma.godziny
ADD Primary Key (id_godziny)
ALTER TABLE firma.pensja
ADD Primary Key (id_pensji)
ALTER TABLE firma.premia
ADD Primary Key (id_premii)
ALTER TABLE firma.wynagrodzenie
ADD Primary Key (id_wynagrodzenia)

ALTER TABLE firma.godziny
ADD Foreign Key(id_pracownika) REFERENCES firma.pracownicy(id_pracownika)
ALTER TABLE firma.wynagrodzenie
ADD Foreign Key(id_pracownika) references firma.pracownicy(id_pracownika)
ALTER TABLE firma.wynagrodzenie
ADD Foreign Key(id_godziny) references firma.godziny(id_godziny)
ALTER TABLE firma.wynagrodzenie
ADD Foreign Key(id_pensji) references firma.pensja(id_pensji)
ALTER TABLE firma.wynagrodzenie
ADD Foreign Key(id_premii) references firma.premia(id_premii)


COMMENT ON TABLE ksiegowosc.pracownicy IS 'Tabela z danymi pracowników';
COMMENT ON TABLE ksiegowosc.godziny IS 'Tabela z danymi godzin przepracowanych przez pracownika ';
COMMENT ON TABLE ksiegowosc.pensja IS 'Tabela z pensjami pracowników';
COMMENT ON TABLE ksiegowosc.premia IS 'Tabela z premiami pracowników';

INSERT INTO firma.pracownicy(id_pracownika, imie, nazwisko, adres,telefon)
VALUES ('P01', 'Karol', 'Atom', 'Słodowskiej 10', '48685741987' ),
('P02', 'Karolina', 'Duda', 'Piaskowa 10', '48688741987' ),
('P03', 'Maciej', 'Technik', 'Lodowa 9', '48789456235' ),
('P04', 'Arnold', 'Mlot', 'Mogilska 2', '48789548621' ),
('P05', 'Adam', 'Grek', 'Mogilska 4', '48741582621'),
('P06', 'Michal', 'Linda', 'Kwiatowa 24', '48456582621' ),
('P07', 'Daniel', 'Taterka', 'Fiolkowa 42', '48456879132' ),
('P08', 'Dawid', 'Sadek', 'Milosza 42', '48985369741' ),
('P09', 'August', 'Norman', 'Mickiewicza 21', '48582647951'),
('P10', 'Tomasz', 'Kaman', 'Piłsudskiego 56', '48354698741');


INSERT INTO firma.pensja(id_pensji, stanowisko, kwota)
VALUES ('PA01', 'dyrektor', 10000),
('PA02', 'vice-dyrektor', 5000),
('PA03', 'księgowa', 5200),
('PA04', 'sekretarka', 2500),
('PA05', 'kierownik', 5000),
('PA06', 'zastępca kierownika', 4000),
('PA07', 'inżynier', 3500),
('PA08', 'młodszy inżynier', 3000),
('PA09', 'kierowca', 3000),
('PA10', 'stazysta', 2100)

INSERT INTO firma.premia(id_premii, rodzaj, kwota)
VALUES ('PM01', 'nadgodziny', 1000),
('PM02', 'nadgodziny', 500),
('PM03', 'nadgodziny', 250),
('PM04', 'kwartalna', 1000),
('PM05', 'kwartalna', 500),
('PM06', 'bonus', 250),
('PM07', 'motywacyjna', 1000),
('PM08', 'motywacyjna', 2000),
('PM09', 'motywacyjna', 1500),
('PM10', 'uznaniowa', 500)

INSERT INTO ksiegowosc.wynagrodzenie(id_wynagrodzenia,data,id_pracownika,id_godziny,id_pensji,id_premii)
VALUES('W01','2020-04-05','P01','G01','PA01','PM03'),
('W02','2020-04-06','P02','G02','PA02','PM03'),
('W03','2020-04-05','P03','G03','PA03','PM01'),
('W04','2020-04-08','P04','G04','PA03','PM07'),
('W05','2020-04-10','P05','G05','PA07','PM08'),
('W06','2020-04-12','P06','G06','PA07','PM10'),
('W07','2020-04-14','P07','G07','PA08','PM05'),
('W08','2020-04-15','P08','G08','PA06','PM06'),
('W09','2020-04-01','P09','G09','PA10','PM01'),
('W10','2020-04-03','P10','G10','PA03','PM01');

Alter Table firma.wynagrodzenie Alter Column data Type Varchar(10)

Select id_pracownika,nazwisko From ksiegowosc.pracownicy

Select W.id_pracownika,PA.kwota as Wynagrodzenie , PM.kwota as Premia From firma.wynagrodzenie W,firma.premia PM,firma.pensja PA
Where W.id_pensji=PA.id_pensji AND W.id_premii=PM.id_premii AND PA.kwota+PM.kwota >1000;

Select W.id_pracownika From firma.wynagrodzenie W, firma.pensja PA
Where W.id_pensji=PA.id_pensji AND w.id_premii is null AND PA.kwota>2000

Select * From firma.pracownicy Where imie like 'J%'

Select * From firma.pracownicy Where imie like '%a' AND nazwisko like '%n%'

Select PR.Imie, PR.Nazwisko From firma.pracownicy PR, firma.godziny GD
	Where PR.id_pracownika =GD.id_pracownika AND GD.liczba_godzin > 160;

Select PR.Imie, PR.Nazwisko From firma.pracownicy PR,firma.wynagrodzenie W,firma.pensja PA
Where PR.id_pracownika= W.id_pracownika AND PA.id_pensji=W.id_pensji AND PA.kwota between 1500 AND 3000

Select PR.Imie, PR.Nazwisko FROM firma.pracownicy PR, firma.godziny GD,firma.wynagrodzenie W
	Where PR.id_pracownika =W.id_pracownika AND GD.id_godziny =W.id_godziny AND GD.liczba_godzin > 160 AND W.id_premii is null;

Select W.id_pracownika FROM firma.wynagrodzenie W,firma.pensja PA 
Where W.id_pensji=PA.id_pensji Order by PA.kwota

Select W.id_pracownika, PA.kwota, PM.kwota FROM firma.pensja PA
	Left join firma.wynagrodzenie W on PA.id_pensji = W.id_pensji 
	Left join firma.premia PM on W.id_premii = PM.id_premii
order by  PA.kwota desc, PM.kwota desc;

Select count(*) stanowisko from firma.pensja
group by stanowisko

Select min(kwota),max(kwota),avg(kwota) from firma.pensja 
Where stanowisko='kierownik'

Select Sum(PA.kwota)+Sum(PM.kwota) as wynagrodzenie FROM firma.wynagrodzenie W
	Left join firma.pensja PA on W.id_pensji = PA.id_pensji 
	Left join firma.premia PM on W.id_premii = PM.id_premii
	
Select PA.Stanowisko,Sum(PA.kwota)+Sum(PM.kwota) as wynagrodzenie FROM firma.wynagrodzenie W
	Left join firma.pensja PA on W.id_pensji = PA.id_pensji 
	Left join firma.premia PM on W.id_premii = PM.id_premii group by PA.stanowisko

Select count(W.id_premii) From firma.wynagrodzenie W
	Left join firma.pensja PA on W.id_pensji=PA.id_pensji group by PA.stanowisko

Delete From firma.wynagrodzenie W
Using firma.pensja PA
Where PA.kwota <1200 AND W.id_pensji=PA.id_pensji

Alter Table firma.pracownicy Alter Column telefon Type Varchar(20)
UPDATE firma.pracownicy
SET telefon= CONCAT('(+48)',telefon)
UPDATE firma.pracownicy
SET telefon= CONCAT(SUBSTRING(telefon,1,8),'-',substring(telefon,9,3),'-',substring(telefon,12,3))

Select UPPER(id_pracownika),UPPER(Imie),UPPER(NAZWISKO),UPPER(adres),UPPER(telefon) from firma.pracownicy order by length(nazwisko) desc limit 1

Select MD5(PR.imie)As Imie,MD5(PR.nazwisko)As Nazwisko,MD5(PR.adres)As Adres,MD5(PR.telefon)As telefon,MD5(PA.stanowisko) as Stanowisko ,MD5(Cast(PA.kwota as Varchar(15))) from firma.pracownicy PR,firma.wynagrodzenie W,firma.pensja PA
Where PR.id_pracownika = W.id_pracownika AND W.id_pensji=PA.id_pensji

Select 'Pracownik '||PR.imie||' '||PR.nazwisko||' w dniu '||W.data||' Otrzymał pensje całkowitą na kwotę '||PA.kwota+PM.kwota||' gdzie wynagrodzenie zasadnicze wynosiło: '|| PA.Kwota||' premia: '||PM.kwota from firma.pracownicy PR,firma.wynagrodzenie W,firma.pensja PA,firma.premia PM
Where PR.id_pracownika = W.id_pracownika AND W.id_pensji=PA.id_pensji AND W.id_premii=PM.id_premii
