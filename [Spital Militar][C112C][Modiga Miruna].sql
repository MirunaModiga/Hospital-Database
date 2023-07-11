USE master
DROP DATABASE IF EXISTS SpitalMilitar

------------------------------------------------CREAREA BAZEI DE DATE-------------------------------------------------------

CREATE DATABASE SpitalMilitar
ON PRIMARY
(
Name = SpitalData,
FileName = 'D:\BD\proiectBD\SpitalMilitar.mdf',
size = 10MB,
maxsize = unlimited,
filegrowth = 1GB
),
(
Name = SpitalData1,
FileName = 'D:\BD\proiectBD\SpitalMilitar1.ndf',
size = 10MB,
maxsize = unlimited,
filegrowth = 1GB
),
(
Name = SpitalData2,
FileName = 'D:\BD\proiectBD\SpitalMilitar2.ndf',
size = 10MB,
maxsize = unlimited,
filegrowth = 1GB
)
LOG ON
(
Name = SpitalLog1,
FileName = 'D:\BD\proiectBD\SpitalMilitar_log1.ldf',
size = 10MB,
maxsize = unlimited,
filegrowth = 1024MB
),(
Name = SpitalLog2,
FileName = 'D:\BD\proiectBD\SpitalMilitar_log2.ldf',
size = 10MB,
maxsize = unlimited,
filegrowth = 1024MB
)
GO

USE SpitalMilitar

-------------------------------------------------------CREAREA TABELELOR-------------------------------------------------------

--crearea tabelului Departamente (1)

IF OBJECT_ID('Departamente','U') is not null
	DROP TABLE Departamente
go
CREATE TABLE Departamente
(
	IDDepartament int IDENTITY (1,1),
	Denumire nvarchar(20) NOT NULL,
	CONSTRAINT PK_Departament PRIMARY KEY(IDDepartament)
)

--crearea tabelului Angajati (2)

IF OBJECT_ID('Angajati', 'U') is not null
	DROP TABLE Angajati
go
CREATE TABLE Angajati
(
	IDAngajat int IDENTITY(1,1),
	Nume nvarchar(20) NOT NULL,
	Prenume nvarchar(20) NOT NULL,
	[Data nastere] date NOT NULL,
	Adresa nvarchar(100) NOT NULL,
	Telefon nvarchar(10) NOT NULL,
	Email nvarchar(50),
	CONSTRAINT PK_Angajati PRIMARY KEY(IDAngajat),
	CONSTRAINT CHK_TelefonA CHECK (isnumeric(Telefon)=1 AND len(Telefon)=10)
)

--crearea tabelului DepartamenteAngajati (3)

IF OBJECT_ID('Departamente Angajati', 'U') is not null
	DROP TABLE [Departamente Angajati]
go
CREATE TABLE [Departamente Angajati]
(
	IDDepartAng int IDENTITY(1,1),
	IDDepartament int NOT NULL,
	IDAngajat int NOT NULL,
	CONSTRAINT PK_DepartAng PRIMARY KEY(IDDepartAng),
	CONSTRAINT FK_IDDepart FOREIGN KEY (IDDepartament) REFERENCES Departamente(IDDepartament) ON DELETE CASCADE,
	CONSTRAINT FK_IDAngajat1 FOREIGN KEY (IDAngajat) REFERENCES Angajati(IDAngajat) ON DELETE CASCADE
)

--crearea tabelului Functii (4)

IF OBJECT_ID('Functii', 'U') is not null
	DROP TABLE Functii
go
CREATE TABLE Functii
(
	IDFunctie int IDENTITY(1,1),
	Denumire nvarchar(40) NOT NULL,
	[Salariu brut] money NOT NULL,
	CONSTRAINT PK_Functii PRIMARY KEY(IDFunctie),
	CONSTRAINT CHK_Functie CHECK (Denumire IN ('Asistent Medical','Medic Specialist','Tehnician Medical','Farmacist','Personal Administrativ','Receptionist'))
)

--crearea tabelului FunctiiAngajati (6)

IF OBJECT_ID('Functii Angajati', 'U') is not null
	DROP TABLE [Functii Angajati]
go
CREATE TABLE [Functii Angajati]
(
	IDFunctAng int IDENTITY(1,1),
	IDAngajat int NOT NULL,
	IDFunctie int NOT NULL,
	[Data început] date NOT NULL,
	[Data final] date,
	CONSTRAINT PK_FunctAng PRIMARY KEY (IDFunctAng),
	CONSTRAINT FK_IDAngajat2 FOREIGN KEY (IDAngajat) REFERENCES Angajati(IDAngajat) ON DELETE CASCADE,
	CONSTRAINT FK_IDFunctie FOREIGN KEY (IDFunctie) REFERENCES Functii(IDFunctie) ON DELETE NO ACTION
)

--crearea tabelului Impozite (5)

IF OBJECT_ID('Impozite', 'U') is not null
	DROP TABLE Impozite
go
CREATE TABLE Impozite
(
	IDImpozit int IDENTITY(1,1),
	Denumire nvarchar(30) NOT NULL,
	Procent float NOT NULL,
	CONSTRAINT PK_Impozite PRIMARY KEY(IDImpozit)
)

--crearea tabelului Impozite Angajati (7)

IF OBJECT_ID('Impozite Angajati' , 'U') is not null
	DROP TABLE [Impozite Angajati]
go
CREATE TABLE [Impozite Angajati]
(
	IDImpoziteAngajati int IDENTITY(1,1),
	IDImpozit int NOT NULL,
	IDAngajat int NOT NULL,
	CONSTRAINT PK_ImpozitAng PRIMARY KEY (IDImpoziteAngajati),
	CONSTRAINT FK_IDAngajat3 FOREIGN KEY (IDAngajat) REFERENCES Angajati(IDAngajat) ON DELETE CASCADE,
	CONSTRAINT FK_IDImpozit FOREIGN KEY (IDImpozit) REFERENCES Impozite(IDImpozit) ON DELETE CASCADE
)

--crearea tabelului Pacienti (8)

IF OBJECT_ID('Pacienti', 'U') is not null
	DROP TABLE Pacienti
go
CREATE TABLE Pacienti
(
	IDPacient int IDENTITY(1,1),
	Nume nvarchar(20) NOT NULL,
	Prenume nvarchar(20) NOT NULL,
	[Data nastere] date NOT NULL,
	CNP nvarchar(13) NOT NULL,
	Adresa nvarchar(100) NOT NULL,
	NrTelefon nvarchar(10) NOT NULL,
	[Grupa sange] varchar(3) NOT NULL,
	Sex CHAR(1) NOT NULL,
	Inaltime numeric(3) NOT NULL,
	Greutate numeric(3,1) NOT NULL,
	[este Militar] char(2) NOT NULL,
	CONSTRAINT PK_Pacienti PRIMARY KEY(IDPacient),
	CONSTRAINT CHK_TelefonP CHECK (isnumeric(NrTelefon)=1 AND len(NrTelefon)=10),
	CONSTRAINT CHK_GrSange CHECK ([Grupa sange] IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
	CONSTRAINT CHK_Greutate CHECK (Greutate BETWEEN 3.0 AND 250.0),
	CONSTRAINT CHK_Sex CHECK (Sex IN('M','F')),
	CONSTRAINT CHK_Militar CHECK ([este Militar] IN('DA','NU')),
	CONSTRAINT CHK_CNP CHECK (isnumeric(CNP)=1 AND len(CNP)=13)
)

--crearea tabelului Programari (9)

IF OBJECT_ID('Programari', 'U') is not null
	DROP TABLE Programari
go
CREATE TABLE Programari
(
	IDProgramare int IDENTITY(1,1),
	IDPacient int NOT NULL,
	IDReceptionist int NOT NULL,
	[Data programare] date NOT NULL,
	[este Urgenta] char(2) NOT NULL,
	CONSTRAINT PK_Programare PRIMARY KEY (IDProgramare),
	CONSTRAINT CHK_Urgenta CHECK([este Urgenta] IN('DA','NU')),
	CONSTRAINT FK_Receptionist FOREIGN KEY (IDReceptionist) REFERENCES [Functii Angajati](IDFunctAng) ON DELETE CASCADE,
	CONSTRAINT FK_PacientProg FOREIGN KEY (IDPacient) REFERENCES Pacienti(IDPacient) ON DELETE CASCADE
)

--crearea tabelului Consultatii (10)

IF OBJECT_ID('Consultatii','U') is not null
	DROP TABLE Consultatii
go
CREATE TABLE Consultatii
(
	IDConsultatie int IDENTITY(1,1),
	--IDPacient int NOT NULL,
	IDProgramare int NOT NULL,
	IDDoctor int NOT NULL,
	Observatii nvarchar(50),
	CONSTRAINT PK_Consult PRIMARY KEY (IDConsultatie),
	CONSTRAINT FK_Programare FOREIGN KEY (IDProgramare) REFERENCES Programari(IDProgramare) ON DELETE CASCADE,
	CONSTRAINT FK_DoctorConsult FOREIGN KEY (IDDoctor) REFERENCES [Functii Angajati](IDFunctAng) ON DELETE NO ACTION
)

--crearea tabelului Proceduri (11)

IF OBJECT_ID('Proceduri', 'U') is not null
	DROP TABLE Proceduri
go
CREATE TABLE Proceduri
(
	IDProcedura int IDENTITY(1,1),
	Denumire nvarchar(40) NOT NULL,
	IDDoctor int NOT NULL,
	CONSTRAINT PK_Procedura PRIMARY KEY (IDProcedura),
	CONSTRAINT FK_IDDoctor FOREIGN KEY (IDDoctor) REFERENCES [Functii Angajati](IDFunctAng) ON DELETE CASCADE
)

--crearea tabelului Categorii Materiale (12)

IF OBJECT_ID('Categorii Materiale', 'U') is not null
	DROP TABLE [Categorii Materiale]
go
CREATE TABLE [Categorii Materiale]
(
	IDCategorie int IDENTITY(1,1),
	Denumire nvarchar(40) NOT NULL,
	CONSTRAINT PK_CategorieMat PRIMARY KEY (IDCategorie)
)

--crearea tabelului	Materiale (13)

IF OBJECT_ID('Materiale', 'U') is not null
	DROP TABLE Materiale
go
CREATE TABLE Materiale
(
	IDMaterial int IDENTITY(1,1),
	Denumire nvarchar(40) NOT NULL,
	IDCategorie int NOT NULL,
	CONSTRAINT PK_Material PRIMARY KEY (IDMaterial),
	CONSTRAINT FK_IDCategorie FOREIGN KEY (IDCategorie) REFERENCES [Categorii Materiale](IDCategorie) ON DELETE CASCADE
)

--crearea tabelului Materiale Procedura (14)

IF OBJECT_ID('Materiale Procedura', 'U') is not null
	DROP TABLE [Materiale Procedura]
go
CREATE TABLE [Materiale Procedura]
(
	IDMaterialeProcedura int IDENTITY(1,1),
	IDMaterial int NOT NULL,
	IDProcedura int NOT NULL,
	CONSTRAINT PK_MatProc1 PRIMARY KEY (IDMaterialeProcedura),
	CONSTRAINT FK_IDProcedura FOREIGN KEY (IDProcedura) REFERENCES Proceduri(IDProcedura) ON DELETE CASCADE,
	CONSTRAINT FK_IDMaterial1 FOREIGN KEY (IDMaterial) REFERENCES Materiale(IDMaterial) ON DELETE CASCADE
)

--crearea tabelului Consultatie Proceduri (15)

IF OBJECT_ID('Consultatie Proceduri' , 'U') is not null
	DROP TABLE [Consultatie Proceduri]
go
CREATE TABLE [Consultatie Proceduri]
(
	IDConsultatieProceduri int IDENTITY(1,1),
	IDConsultatie int NOT NULL,
	IDMaterialeProcedura int NOT NULL,
	Pret int NOT NULL,
	CONSTRAINT PK_ConsultProc PRIMARY KEY (IDConsultatieProceduri),
	CONSTRAINT FK_IDConsult2 FOREIGN KEY (IDConsultatie) REFERENCES Consultatii(IDConsultatie) ON DELETE CASCADE,
	CONSTRAINT FK_MatProc2 FOREIGN KEY (IDMaterialeProcedura) REFERENCES [Materiale Procedura](IDMaterialeProcedura) ON DELETE NO ACTION
)

--crearea tabelului Furnizori (16)

IF OBJECT_ID('Furnizori','U') is not null
	DROP TABLE Furnizori
go
CREATE TABLE Furnizori
(
	IDFurnizor int IDENTITY(1,1),
	Nume nvarchar(30) NOT NULL,
	Adresa nvarchar(40) NOT NULL,
	Telefon nvarchar(10) NOT NULL,
	CONSTRAINT PK_Furnizor PRIMARY KEY (IDFurnizor),
	CONSTRAINT CHK_TelefonF CHECK (isnumeric(Telefon)=1 AND len(Telefon)=10)
)

--crearea tabelului Materiale Furnizori (17)

IF OBJECT_ID('Materiale Furnizori','U') is not null
	DROP TABLE [Materiale Furnizori]
go
CREATE TABLE [Materiale Furnizori]
(
	IDMaterialeFurnizori int IDENTITY(1,1),
	IDMaterial int NOT NULL,
	IDFurnizor int NOT NULL,
	CONSTRAINT PK_MatFurnizor PRIMARY KEY (IDMaterialeFurnizori),
	CONSTRAINT FK_IDFurnizor FOREIGN KEY (IDFurnizor) REFERENCES Furnizori(IDFurnizor) ON DELETE CASCADE,
	CONSTRAINT FK_IDMaterial2 FOREIGN KEY (IDMaterial) REFERENCES Materiale(IDMaterial) ON DELETE CASCADE
)

--crearea tabelului Reteta (18)

IF OBJECT_ID('Reteta','U') is not null
	DROP TABLE Reteta
go
CREATE TABLE Reteta
(
	IDReteta int IDENTITY(1,1),
	IDMedicament int NOT NULL,
	IDConsultatieProceduri int NOT NULL,
	IDDoctor int NOT NULL,
	Observatii nvarchar(50) NOT NULL,
	CONSTRAINT PK_Reteta PRIMARY KEY (IDReteta),
	CONSTRAINT FK_ConsultProc1 FOREIGN KEY (IDConsultatieProceduri) REFERENCES [Consultatie Proceduri](IDConsultatieProceduri) ON DELETE CASCADE
)

--crearea tabelului Factura pacient (19)

IF OBJECT_ID('Factura pacient','U') is not null
	DROP TABLE [Factura pacient]
go
CREATE TABLE [Factura pacient]
(
	IDFactura int IDENTITY(1,1),
	IDConsultatieProceduri int NOT NULL,
	ModPlata char(4) NOT NULL,
	CONSTRAINT PK_Factura PRIMARY KEY (IDFactura),
	CONSTRAINT FK_ConsultProc2 FOREIGN KEY (IDConsultatieProceduri) REFERENCES [Consultatie Proceduri](IDConsultatieProceduri) ON DELETE CASCADE,
	CONSTRAINT CHK_Plata CHECK (ModPlata IN('CASH','CARD'))
)

-- crearea tabelului Internari (20)

IF OBJECT_ID('Internari','U') is not null
	DROP TABLE Internari
go
CREATE TABLE Internari
(
	IDInternare int IDENTITY(1,1),
	[Data Internare] date NOT NULL,
	IDConsultatie int NOT NULL,
	Diagnostic nvarchar(50) NOT NULL,
	CONSTRAINT PK_Internare PRIMARY KEY(IDInternare),
	CONSTRAINT FK_ConsulIntern FOREIGN KEY (IDConsultatie) REFERENCES Consultatii(IDConsultatie) ON DELETE CASCADE
)

--crearea tabelului Externari (21)

IF OBJECT_ID('Externari','U') is not null
	DROP TABLE Externari
go
CREATE TABLE Externari
(
	IDExternare int IDENTITY(1,1),
	IDPacient int NOT NULL,
	[Data Externare] date NOT NULL,
	[Raport Evaluare] nvarchar(50) NOT NULL,
	CONSTRAINT PK_Externare PRIMARY KEY(IDExternare),
	CONSTRAINT FK_PacientExtern FOREIGN KEY (IDPacient) REFERENCES Pacienti(IDPacient) ON DELETE CASCADE
)


-------------------------------------------------------INSERTURI-------------------------------------------------------

--1. Populare tabela Departamente 

INSERT INTO Departamente(Denumire)
VALUES
('Medicina Interna'),('Chirurgie'),('ATI'),('Dermatovenerologie'),('Neurologie'),('Ginecologie'),('Oftalmologie/ORL'),('Laborator'),('Administrare')

--2. Populare tabela Functii 

INSERT INTO Functii(Denumire,[Salariu Brut])
VALUES
('Asistent Medical',3500),
('Medic Specialist',9000),
('Tehnician Medical',7000),
('Farmacist',6500),
('Personal Administrativ',2000),
('Receptionist',3000)

--3. Populare tabela Angajati 

INSERT INTO Angajati(Nume,Prenume,[Data nastere],Adresa,Telefon,Email)
VALUES
('Popescu','Maria','1980-07-15','Calea Rahovei 185','0765554321','maria_popescu@yahoo.com'),
('Vasilescu','Ion','1997-02-12','Strada Toamnei 2','0793512321','vasilescu_ion@yahoo.com'),
('Mihai','Ana','1996-05-11','Valea Doftanei 10','0732341322','anaMihai@yahoo.com'),
('Ionescu','Viorel','1980-01-02','Soseaua Oltenitei 15','0723230002','ionescu_viorel@yahoo.com'),
('Popa','Ioana','1990-01-02','Strada Motilor 5','0756789902','popaioana@gmail.com'),
('Pop','Andrei','1981-08-16','Bulevardul Primaverii 3','0733433210','andreiPop@yahoo.com'),
('Popovici','Victor','1987-10-18','Strada Grigore Manolescu 14','0723332098','popoVictor2@yaoo.com'),
('Dumitrescu','George','1990-03-10','Voluntari','0762312342','georgedumi@yahoo.com'),
('Stoica','Raluca','1985-05-25','Strada Codrii Neamtului','0712344321',NULL)

--4. Populare tabela Departamente Angajati

INSERT INTO [Departamente Angajati](IDDepartament,IDAngajat)
VALUES
(1,3),(2,1),(8,4),(4,2),(9,9),(8,5),(7,6),(9,8),(9,7)

--5. Populare tabela Functii Angajati

INSERT INTO [Functii Angajati](IDAngajat,IDFunctie,[Data început],[Data final])
VALUES
(1,1,'2019-02-03','2020-01-15'),
(1,2,'2020-01-15',NULL),
(2,2,'2010-01-15',NULL),
(3,2,'2015-03-13',NULL),
(4,3,'2019-02-03',NULL),
(5,4,'2016-05-14',NULL),
(6,1,'2015-01-03','2016-03-07'),
(6,2,'2016-03-07',NULL),
(7,5,'2016-03-07',NULL),
(8,6,'2015-01-03',NULL),
(9,6,'2015-01-03',NULL)

--6. Populare tabela Impozite

INSERT INTO Impozite(Denumire, Procent)
VALUES
('Asigurari sociale',0.1),
('Asigurari de sanatate',0.25),
('Fondul de somaj',0.05),
('Impozit pe casa',0.05),
('Impozit pe masina',0.03)

--7. Populare tabela Impozite Angajati

INSERT INTO [Impozite Angajati](IDAngajat,IDImpozit)
VALUES 
(1,1),(1,2),(1,3),(1,4),(1,5),
(2,1),(2,2),(2,3),(2,4),(2,5),
(3,1),(3,2),(3,3),(3,4),(3,5),
(4,1),(4,2),(4,3),
(5,1),(5,2),(5,3),(5,4),
(6,1),(6,2),(6,3),(6,5),
(7,1),(7,2),(7,3),(7,4),(7,5),
(8,1),(8,2),(8,3),(8,5),
(9,1),(9,2),(9,3)

--8. Populare tabela Proceduri 

INSERT INTO Proceduri(Denumire,IDDoctor)
VALUES
('Administrare medicamente',1),('Intubare',4),('Radiografie',7),
('Transfuzie sange',6),('Analize medicale',8),('Dializa',2),
('EKG',5),('Proceduri chirurgicale',3)

--9. Populare tabela Furnizori

INSERT INTO Furnizori(Nume,Adresa,Telefon)
VALUES
('ThreePharm','Str. Evreilor Targu-Mures','0745674324'),
('TIMEX-FARM SRL','Calea Urseni Timisoara','0788342765'),
('SMART MEDICAL','Str. Dunarii Alexandria','0786566232')

--10. Populare tabela Categorii Materiale 

INSERT INTO [Categorii Materiale](Denumire)
VALUES
('Instrumentar chirurgical'),('Medicamente'),('Echipamente monitorizare pacienti'),('Echipamente examinare si diagnosticare'),('Echipamente de protectie')

--11. Populare tabela Materiale

INSERT INTO Materiale(Denumire,IDCategorie)
VALUES
('Manusi chirurgicale',5),('Masti de protectie',5),('Pastile',2),('Picaturi',2),('Clesti',4),('Scalpeli',1),
('Electrocardiograf',4),('Seringi si ace',1),('Aparate anestezie',1),('Monitoare',3),
('Ventilator',3),('Oftalmoscop',4),('Otoscop',4),('Aparat de dializa',3),('Set de tuburi',3)

--12. Populare tabela Materiale Furnizori 

INSERT INTO [Materiale Furnizori](IDMaterial,IDFurnizor)
VALUES
(1,1),(2,3),(3,2),(4,1),(5,1),
(6,2),(7,3),(8,2),(9,1),(10,3),
(11,3),(12,2),(13,1),(14,2),(15,3)

--13. Populare tabela Materiale Procedura

INSERT INTO [Materiale Procedura](IDMaterial,IDProcedura)
VALUES
(1,8),(2,4),(3,1),(4,1),(5,8),(6,8),
(7,7),(8,4),(9,8),(10,3),(11,2),
(12,5),(13,5),(14,6),(15,2)

--14. Populare tabela Pacienti

INSERT INTO Pacienti(Nume,Prenume,[Data nastere],CNP,Adresa,NrTelefon,[Grupa sange],Sex,Inaltime,Greutate,[este Militar])
VALUES
('Popa','Irina','2002-01-18','6020118167325','Strada Garii nr.2','0745603455','A+','F',180,65.3,'DA'),
('Onofrei','Stefan','1997-07-07','1970707120254','Strada Ilfov nr.6','0735653451','AB-','M',169,79.8,'NU'),
('Zamfir','Sara','2001-03-05','6010503108461','Strada Oltenitei 35-45','0760235488','O+','F',172,60.5,'NU'),
('Crihana','Dragos','2000-05-10','5000510517921','Strada Leonida nr.1','0755602964','AB+','M',187,75,'DA'),
('Sandu','Vasile','1994-11-08','1940510130766','Strada Tineretului','0755432671','A+','M',192,89.5,'NU'),
('Calinescu','Marina','1998-10-02','2981002097116','Strada 11 iunie','0735441655','O+','F',165,60,'NU'),
('Carutasu','Cristina','1978-12-20','2781220379901','Strada	Milcov nr.5','0741672344','A+','F',178,68.2,'NU'),
('Rotaru','Razvan','1999-02-16','1990216389094','Strada Antim nr.10','0741603405','A-','M',182,90,'DA'),
('Pricop','Sebastian','1987-04-11','1870411337917','Strada Stefan cel Mare','0742663425','A+','M',195,98.6,'NU'),
('Avram','Mara','1992-03-10','2920310338119','Strada Bucovinei','0755660445','AB+','F',190,95,'NU')

--15. Populare tabela Programari

INSERT INTO Programari(IDPacient, IDReceptionist,[Data programare],[este Urgenta])
VALUES
(1,8,'2023-04-01','NU'),
(2,9,'2023-05-03','DA'),
(3,8,'2023-04-11','NU'),
(4,9,'2022-10-20','NU'),
(5,8,'2022-09-15','NU'),
(6,9,'2023-02-10','NU'),
(7,9,'2023-05-01','DA'),
(8,8,'2022-06-29','NU'),
(9,8,'2021-12-09','NU'),
(10,9,'2022-08-18','NU')

--16. Populare tabela Consultatii

INSERT INTO Consultatii(IDProgramare,IDDoctor,Observatii)
VALUES
(1,1,'Revenire la consultatie peste 4 luni'),
(2,6,'Necesita operatie si recuperare'),
(3,2,'Nu este nevoie de tratament'),
(4,1,'Este recomandata hidratarea excesiva'),
(5,1,'Incepere purtat ochelari'),
(6,2,'Radiografie buna'),
(7,3,'Necesita tratament + recuperare 4 luni'),
(8,3,'Necesita operatie si regim alimentar'),
(9,2,'Repaus la pat timp de 5 luni'),
(10,6,'Electrocardiograma reusita')

--17. Populare tabela Consultatie Proceduri

INSERT INTO [Consultatie Proceduri](IDConsultatie,IDMaterialeProcedura, Pret)
VALUES
(1,3,150),
(2,1,400),
(3,8,320),
(4,2,400),
(5,12,180),
(6,10,150),
(7,13,800),
(8,5,700),
(9,6,650),
(10,7,250)

--18. Populare tabela Internari

INSERT INTO Internari([Data Internare],IDConsultatie,Diagnostic) 
VALUES
('2023-05-03',2,'Ruptura de ligamente, recomandari: fizioterapie'),
('2023-05-01',7,'Tuberculoza, recomandari: odihna'),
('2022-06-29',8,'Hernie de disc, recomandari: regim alimentar'),
('2021-12-09',9,'Pneumonie severa, monitorizare + tratament')

--19. Populare tabela Externari

INSERT INTO Externari(IDPacient,[Data Externare],[Raport Evaluare])
VALUES
(2,'2023-07-03','Continuare fizioterapie, control lunar'),
(7,'2023-09-01','Continuare tratament + masuri de igiena buna'),
(8,'2023-08-01','Continuare regim alimentar'),
(9,'2022-02-09','Odihna + fara efort')

--20. Populare tabela Reteta

INSERT INTO Reteta(IDMedicament, IDConsultatieProceduri, IDDoctor, Observatii)  
VALUES
(3,1,1,'1/zi, dimineata, inainte de micul dejun'),
(5,5,1,'3 picaturi/zi, in fiecare ochi, pt 2 saptamani')

--21. Populare tabela Factura pacient

INSERT INTO [Factura pacient](IDConsultatieProceduri, ModPlata)
VALUES
(1,'CASH'),
(5,'CARD'),
(6,'CASH'),
(10,'CARD')


-------------------------------------------------------SELECT-------------------------------------------------------


----------------------------OPERATORI PE SETURI DE DATE-------------------------

--22. Afisati numele, prenumele si numarul de telefon al angajatilor si al pacientilor inregistrati in cadrul Spitalului Militar.

SELECT Nume, Prenume, Telefon FROM Angajati
UNION 
SELECT Nume, Prenume, NrTelefon FROM Pacienti

--23. Selectati anii in care sunt nascuti cel putin un angajat, cat si un pacient.

SELECT YEAR([Data nastere]) as [An de nastere comun]
FROM Pacienti
INTERSECT
SELECT YEAR([Data nastere])
FROM Angajati

--24. Afisati toate functiile angajatilor, cat si denumirile departamentelor, cat si duplicatele, daca exista.

SELECT Denumire
FROM Departamente
UNION ALL
SELECT Denumire
FROM Functii

--25. Afisati toate adresele la care locuiesc angajati, dar niciun pacient.

SELECT Adresa
FROM Angajati
EXCEPT
SELECT Adresa
FROM Pacienti


-------------------------GRUPARI DE DATE------------------------

--26. Afisati cate impozite se aplica pe fiecare angajat.
SELECT IdAngajat, Count(IDImpozit) AS NrImpozite
FROM [Impozite Angajati]
GROUP BY IdAngajat

--27. Afisati numarul de angajati care ocupa aceeasi functie.

SELECT IDFunctie, Count(IDAngajat) AS NrAngajati
FROM [Functii Angajati]
GROUP BY IdFunctie

--28.  Afisati numarul de angajati care au fost nascuti in fiecare an.

SELECT Year([Data nastere]) as AnNastere, Count(IdAngajat) as NrAngajati
FROM Angajati
GROUP BY Year([Data nastere])

--29. Afisati numarul de materiale necesare pentru fiecare procedura.

SELECT IDProcedura, Count(IDMaterial) AS NrMateriale
FROM [Materiale Procedura]
GROUP BY IDProcedura

--30. Afisati pacientii in functie de greutate

SELECT MAX(Nume) AS Nume, MAX(Prenume) AS Prenume, Greutate
FROM Pacienti
GROUP BY Pacienti.Greutate

--------------------------GRUPAREA DATELOR FILTRATE-----------------------

--31. Afisati nr de angajati care sunt nascuti in luna mai.

SELECT Month([Data nastere]) as LunaNastere, Count(IdAngajat) as NrAngajati
FROM Angajati
WHERE Month([Data nastere])=5
GROUP BY Month([Data nastere])

--32. Afisati pacientii de sex feminin

SELECT Nume, Prenume, Sex 
FROM Pacienti
WHERE Sex = 'F'
GROUP BY Nume, Prenume, Sex

--33. Selectati pacientii care sunt militari

SELECT Nume,Prenume,CNP,[este Militar]
FROM Pacienti
WHERE [este Militar] = 'DA'
GROUP BY Nume,Prenume,CNP,[este Militar]

--34. Selectați numele departamentului și numărul de angajați din fiecare departament din tabelul "Angajati".

SELECT D.Denumire, COUNT(*) AS [Numar Angajati]
FROM Departamente AS D 
INNER JOIN [Departamente Angajati] AS DA ON D.IDDepartament = DA.IDDepartament 
INNER JOIN Angajati AS A ON A.IDAngajat = DA.IDAngajat
GROUP BY D.Denumire

--35. Selectati angajatii din spital care detin masina personala (dupa impozitul de masina)

SELECT Nume, Prenume
FROM Angajati
INNER JOIN [Impozite Angajati] ON Angajati.IDAngajat=[Impozite Angajati].IDAngajat
INNER JOIN Impozite ON Impozite.IDImpozit=[Impozite Angajati].IDImpozit
WHERE Impozite.Denumire='Impozit pe masina'
GROUP BY Nume, Prenume

--36. Selectati angajatii incadrati pe functia de medic specialist

SELECT Nume,Prenume,Telefon
FROM Angajati AS A 
INNER JOIN [Functii Angajati] AS FA ON A.IDAngajat = FA.IDAngajat
INNER JOIN Functii AS F ON F.IDFunctie = FA.IDFunctie
WHERE F.Denumire='Medic specialist' AND FA.[Data final] is null
GROUP BY Nume,Prenume,Telefon

--37. Selectati materialele de la firma SMART MEDICAL

SELECT M.*
FROM Materiale AS M 
INNER JOIN [Materiale Furnizori] AS MF ON M.IDMaterial=MF.IDMaterial
INNER JOIN Furnizori AS F ON F.IDFurnizor=MF.IDFurnizor
WHERE F.Nume ='SMART MEDICAL'

--38. Rezolvati aceeasi cerinta folosind subinterogari

SELECT Materiale.*
FROM Materiale 
INNER JOIN [Materiale Furnizori] ON Materiale.IDMaterial = [Materiale Furnizori].IDMaterial
WHERE [Materiale Furnizori].IDFurnizor IN (SELECT IDFurnizor Furnizori WHERE IDFurnizor=3)


-----------------------------FILTRARE DE GRUP---------------------------

--39. Afisati numele, prenumele, functia si data numirii in functie a tuturor angajatilor care inca lucreaza pe functia numita.

SELECT Nume, Prenume, F.Denumire, FA.[Data început]
FROM Angajati AS A
INNER JOIN [Functii Angajati] AS FA ON FA.IdAngajat=A.IdAngajat
INNER JOIN Functii AS F ON F.IdFunctie=FA.IdFunctie
GROUP BY Nume, Prenume, F.Denumire, FA.[Data început], [Data final]
HAVING FA.[Data final] is null

--40. Afisati numarul salariatilor angajati in fiecare an dupa anul 2015

SELECT YEAR(FA.[Data început]) AS Ani ,COUNT(A.IdAngajat) as NrSalariati
FROM Angajati AS A
INNER JOIN [Functii Angajati] AS FA ON FA.IdAngajat=A.IdAngajat
GROUP BY YEAR(FA.[Data început])
HAVING YEAR(FA.[Data început])>2015

--41. Afisati pacientii care au fost internati dupa anul 2023, inclusiv.

SELECT P.Nume, P.Prenume, I.[Data Internare], I.Diagnostic
FROM Pacienti AS P 
INNER JOIN Programari AS PR ON P.IDPacient = PR.IDPacient
INNER JOIN Consultatii AS C ON PR.IDProgramare = C.IDProgramare
INNER JOIN Internari AS I ON I.IDConsultatie = C.IDConsultatie
GROUP BY I.[Data Internare],P.Nume, P.Prenume, I.Diagnostic
HAVING I.[Data Internare] >'2023-01-01'

--42. Selectati programarile facute de angajata Stoica Raluca

SELECT A.Nume, A.Prenume, P.IDReceptionist, P.IDProgramare, P.[Data programare]
FROM Programari AS P
INNER JOIN [Functii Angajati] AS FA ON P.IDReceptionist=FA.IDAngajat
INNER JOIN Angajati AS A ON A.IDAngajat=FA.IDAngajat
GROUP BY A.Nume, A.Prenume, P.IDReceptionist, P.IDProgramare, P.[Data programare]
HAVING A.Nume = 'Stoica' AND A.Prenume = 'Raluca'


-------------------------JOIN-URI PE CEL PUTIN 3 TABELE--------------------------

--43. Afisati clientii care au necesitat operatii

SELECT Pacienti.*
FROM Pacienti  
INNER JOIN Programari ON Pacienti.IDPacient = Programari.IDPacient
INNER JOIN Consultatii ON Programari.IDProgramare = Consultatii.IDProgramare
INNER JOIN [Consultatie Proceduri] ON [Consultatie Proceduri].IDConsultatie= Consultatii.IDConsultatie
INNER JOIN [Materiale Procedura] ON [Materiale Procedura].IDMaterialeProcedura= [Consultatie Proceduri].IDMaterialeProcedura
INNER JOIN Proceduri ON [Materiale Procedura].IDProcedura= Proceduri.IDProcedura
WHERE Proceduri.Denumire = 'Proceduri chirurgicale'

--44. Afisati pacientii care au platit cash in urma externarii

SELECT Pacienti.*
FROM Pacienti
INNER JOIN Programari ON Pacienti.IDPacient = Programari.IDPacient
INNER JOIN Consultatii ON Programari.IDProgramare = Consultatii.IDProgramare
INNER JOIN [Consultatie Proceduri] ON [Consultatie Proceduri].IDConsultatie = Consultatii.IDConsultatie
INNER JOIN [Factura pacient] ON [Factura pacient].IDConsultatieProceduri = [Consultatie Proceduri].IDConsultatieProceduri
WHERE [Factura pacient].ModPlata = 'CASH' AND Pacienti.[este Militar] = 'NU'

--45. Afisati pacientii carora le-a fost eliberata o reteta 

SELECT Pacienti.*
FROM Pacienti  
INNER JOIN Programari ON Pacienti.IDPacient = Programari.IDPacient
INNER JOIN Consultatii ON Programari.IDProgramare = Consultatii.IDProgramare
INNER JOIN [Consultatie Proceduri] ON [Consultatie Proceduri].IDConsultatie= Consultatii.IDConsultatie
INNER JOIN Reteta ON Reteta.IDConsultatieProceduri = [Consultatie Proceduri].IDConsultatieProceduri

--46. Afisati medicul care a executat proceduri chirurgicale

SELECT A.*
FROM Angajati AS A
INNER JOIN [Functii Angajati] AS FA ON A.IDAngajat = FA.IDAngajat
INNER JOIN Proceduri AS P ON P.IDDoctor = FA.IDAngajat
WHERE P.Denumire = 'Proceduri chirurgicale'

--47. Afisati procedurile la care nu a luat parte medicul care executa procedurile chirurgicale

SELECT DISTINCT P.*
FROM Proceduri AS P
INNER JOIN [Functii Angajati] AS FA ON FA.IDAngajat = P.IDDoctor
INNER JOIN [Materiale Procedura] AS MP ON MP.IDProcedura = P.IDProcedura
INNER JOIN [Consultatie Proceduri] AS CP ON CP.IDMaterialeProcedura = MP.IDMaterialeProcedura
INNER JOIN Consultatii AS C ON C.IDConsultatie = CP.IDConsultatie
WHERE P.IDDoctor NOT IN (SELECT A.IDAngajat FROM Angajati AS A
INNER JOIN [Functii Angajati] AS FA ON A.IDAngajat = FA.IDAngajat
INNER JOIN Proceduri AS P ON P.IDDoctor = FA.IDAngajat
WHERE P.Denumire = 'Proceduri chirurgicale')

--48. Selectati cel mai mare salariu brut

SELECT MAX(Functii.[Salariu Brut]) AS [Salariu Maxim Brut]
FROM Functii

--49. Afisati impozitele angajatului Mihai Ana

SELECT Angajati.Nume, Angajati.Prenume, Impozite.Denumire, Impozite.Procent
FROM Impozite
INNER JOIN [Impozite Angajati] ON [Impozite Angajati].IDImpozit = Impozite.IDImpozit
INNER JOIN Angajati ON Angajati.IDAngajat = [Impozite Angajati].IDAngajat
WHERE Angajati.Nume = 'Mihai' AND Angajati.Prenume = 'Ana'

--50. Afisati numele si prenumele pacientului cu cea mai scumpa interventie.

SELECT P.Nume, P.Prenume, CP.Pret
FROM Pacienti AS P
INNER JOIN Programari AS PR ON PR.IDPacient = P.IDPacient
INNER JOIN Consultatii AS C ON C.IDProgramare = PR.IDProgramare
INNER JOIN [Consultatie Proceduri] AS CP ON CP.IDConsultatie = C.IDConsultatie
WHERE CP.Pret=(SELECT MAX(Pret) FROM [Consultatie Proceduri])

 --51. Afisati cea mai scumpa interventie

SELECT P.Denumire, CP.Pret
FROM Proceduri AS P
INNER JOIN [Materiale Procedura] AS MP ON MP.IDProcedura=P.IDProcedura
INNER JOIN [Consultatie Proceduri] AS CP ON CP.IDMaterialeProcedura=MP.IDMaterialeProcedura
WHERE CP.Pret=(SELECT MAX(Pret) FROM [Consultatie Proceduri])

--52. Selectati cate programari a facut fiecare receptionist

SELECT A.Nume, A.Prenume, COUNT(P.IDReceptionist) AS [Numar Programari]
FROM Programari AS P
INNER JOIN [Functii Angajati] AS FA ON P.IDReceptionist=FA.IDAngajat
INNER JOIN Angajati AS A ON A.IDAngajat=FA.IDAngajat
GROUP BY A.Nume, A.Prenume

--53. Selectati programarile care sunt urgente 

SELECT * 
FROM Programari
WHERE [este Urgenta]='DA'

--54. Selectati furnizorii din Targu-Mures

SELECT * FROM Furnizori
WHERE Adresa = all
(SELECT Adresa FROM Furnizori
WHERE Adresa LIKE '%Targu-Mures%')

--55. Afiseaza pacientii consultati de angajatul cu id-ul 3

SELECT P.Nume, P.Prenume, C.IDDoctor
FROM Pacienti AS P
INNER JOIN Programari AS PR ON PR.IDPacient=P.IDPacient
INNER JOIN Consultatii AS C ON C.IDProgramare=PR.IDProgramare
WHERE C.IDDoctor=3

--56. Afisati medicul care a consultat cei mai multi pacienti

SELECT TOP 1 A.Nume, A.Prenume, COUNT(C.IDConsultatie) AS [Numar Consultatii]
FROM Angajati AS A
INNER JOIN [Functii Angajati] AS FA ON FA.IDAngajat=A.IDAngajat
INNER JOIN Consultatii AS C ON C.IDDoctor=FA.IDAngajat
GROUP BY A.IDAngajat, A.Nume, A.Prenume
ORDER BY COUNT(*) DESC

--57. Afisati functia si angajatul cu cel mai mic salariu brut

SELECT A.Nume,A.Prenume,F.Denumire, F.[Salariu brut]
FROM Functii AS F 
INNER JOIN [Functii Angajati] AS FA ON FA.IDFunctie =F.IDFunctie
INNER JOIN Angajati AS A ON A.IDAngajat = FA.IDAngajat
WHERE F.[Salariu brut] = (SELECT MIN([Salariu brut]) FROM Functii)

--58. Afisati fiecare functie a angajtilor din spital, si salariul mediu corespunzator functiei, sortate descrescator

SELECT F.denumire AS Functie, AVG(F.[Salariu brut]) AS SalariuMediu
FROM Functii AS F
INNER JOIN [Functii Angajati] AS FA ON F.IDFunctie= FA.IDFunctie
INNER JOIN Angajati AS A ON FA.IDAngajat = A.IDAngajat
GROUP BY F.denumire
ORDER BY SalariuMediu DESC

--59. Selectati materialele de care dispune spitalul, sortate dupa categorii

SELECT M.Denumire, CM.Denumire
FROM Materiale AS M
INNER JOIN [Categorii Materiale] AS CM ON CM.IDCategorie = M.IDCategorie
GROUP BY CM.Denumire,M.Denumire

--60. Sa se afiseze data programarii pacientului Popa Irina

SELECT Pacienti.Nume,Pacienti.Prenume,[Data programare], [este Urgenta]
FROM Programari
INNER JOIN Pacienti ON Pacienti.IDPacient=Programari.IDPacient
WHERE Pacienti.Nume='Popa' AND Pacienti.Prenume='Irina'

-------------------------VIEWS-------------------------

--61. Creati un view cu impozitul total al fiecarui angajat

GO
IF OBJECT_ID('Impozite Totale', 'V') is not null
	DROP VIEW [Impozite Totale]
GO
CREATE VIEW [Impozite Totale]
AS
WITH ImpoziteCTE AS
(
	SELECT [Impozite Angajati].IDAngajat AS ID,SUM(Impozite.Procent) AS [Impozit Total]
	FROM Impozite
	INNER JOIN [Impozite Angajati] ON [Impozite Angajati].IDImpozit=Impozite.IDImpozit
	INNER JOIN Angajati ON Angajati.IDAngajat=[Impozite Angajati].IDImpozit
	GROUP BY [Impozite Angajati].IDAngajat
)
SELECT ID, Angajati.Nume,Angajati.Prenume, [Impozit Total] FROM ImpoziteCTE
INNER JOIN Angajati ON Angajati.IDAngajat = ID

GO
SELECT * FROM [Impozite Totale]

--62. Creati un view cu salariul NET al fiecarui angajat.

GO
IF OBJECT_ID('Salariu net', 'V') is not null
	DROP VIEW [Salariu net]
GO
CREATE VIEW [Salariu net]
AS
	SELECT Angajati.IDAngajat, Angajati.Nume, Angajati.Prenume, (Functii.[Salariu Brut]-Functii.[Salariu Brut]*[Impozite Totale].[Impozit Total]) AS [Salariu NET]
	FROM Angajati
	INNER JOIN [Impozite Totale] ON [Impozite Totale].ID=Angajati.IDAngajat
	INNER JOIN [Functii Angajati] ON [Functii Angajati].IDAngajat=Angajati.IDAngajat
	INNER JOIN Functii ON Functii.IDFunctie=[Functii Angajati].IDFunctie
	WHERE [Functii Angajati].[Data final] is null

GO
SELECT * FROM [Salariu net]

--63. Creati un view cu pacientii, procedurile efectuate asupra acestora, cat si angajatii care au efectuat procedura.

GO
IF OBJECT_ID('Proceduri pacienti', 'V') is not null
	DROP VIEW [Proceduri pacienti]
GO
CREATE VIEW [Proceduri pacienti]
AS
	SELECT DISTINCT P.Nume AS [Nume Pacient], P.Prenume AS [Prenume Pacient], PR.[Data programare], PRC.Denumire, A.Nume AS [Nume Angajat], A.Prenume AS [Prenume Angajat]
	FROM Pacienti AS P 
	INNER JOIN Programari AS PR ON P.IDPacient=PR.IDPacient
	INNER JOIN Consultatii AS C ON C.IDProgramare=PR.IDProgramare
	INNER JOIN [Consultatie Proceduri] AS CP ON CP.IDConsultatie=C.IDConsultatie
	INNER JOIN [Materiale Procedura] AS MP ON MP.IDMaterialeProcedura=CP.IDMaterialeProcedura
	INNER JOIN Proceduri AS PRC ON PRC.IDProcedura=MP.IDProcedura
	INNER JOIN [Functii Angajati] AS F ON F.IDAngajat=PRC.IDDoctor
	INNER JOIN Angajati AS A ON A.IDAngajat=F.IDAngajat

GO
SELECT * FROM [Proceduri pacienti]

--64. Creati un view cu toate materialele furnizate de SMART MEDICAL, cat si categoria din care fac parte

GO
IF OBJECT_ID('Materiale SMART MEDICAL', 'V') is not null
	DROP VIEW [Materiale SMART MEDICAL]
GO
CREATE VIEW [Materiale SMART MEDICAL]
AS
	SELECT F.IDFurnizor, M.Denumire AS [Denumire Material], CM.Denumire AS Categorie
	FROM Materiale AS M
	INNER JOIN [Materiale Furnizori] AS MF ON MF.IDMaterial=M.IDMaterial
	INNER JOIN Furnizori AS F ON F.IDFurnizor=MF.IDFurnizor
	INNER JOIN [Categorii Materiale] AS CM ON CM.IDCategorie=M.IDCategorie
	WHERE F.Nume = 'SMART MEDICAL'

GO
SELECT * FROM [Materiale SMART MEDICAL]

--65. Creati un view cu suma totala platita de pacientii militari.

GO
IF OBJECT_ID('Pret Total Pacienti', 'V') is not null
	DROP VIEW [Pret Total Pacienti]
GO
CREATE VIEW [Pret Total Pacienti]
AS
WITH PretCTE AS
(
	SELECT P.IDPacient AS ID,FP.ModPlata AS [Mod Plata], (CP.Pret*20)/100 AS [Pret Redus],CP.Pret AS [Pret Total] 
	FROM [Consultatie Proceduri] AS CP
	INNER JOIN Consultatii AS C ON C.IDConsultatie=CP.IDConsultatie
	INNER JOIN Programari AS PR ON PR.IDProgramare=C.IDProgramare
	INNER JOIN Pacienti AS P ON P.IDPacient=PR.IDPacient
	INNER JOIN [Factura pacient] AS FP ON FP.IDConsultatieProceduri=CP.IDConsultatieProceduri
	WHERE P.[este Militar]='DA'
)
SELECT ID, Pacienti.Nume, Pacienti.Prenume, Pacienti.[este Militar],[Mod Plata],[Pret Redus],[Pret Total]
FROM PretCTE
INNER JOIN Pacienti ON Pacienti.IDPacient = ID

GO
SELECT * FROM [Pret Total Pacienti]

--66. Creati un view cu diagnosticul dat fiecarui pacient de catre medic in cadrul unei consultatii.

GO
IF OBJECT_ID('Diagnostic Pacienti','V') is not null
	DROP VIEW [Diagnostic Pacienti]
GO
CREATE VIEW [Diagnostic Pacienti]
AS
WITH DiagnosticCTE AS
(
	SELECT C.IDDoctor AS ID, P.Nume AS [Nume Pacient], P.Prenume AS [Prenume Pacient],C.Observatii AS Diagnostic
	FROM Consultatii AS C
	INNER JOIN Programari AS PR ON PR.IDProgramare=C.IDProgramare
	INNER JOIN Pacienti AS P ON P.IDPacient=PR.IDPacient
	INNER JOIN [Functii Angajati] AS FA ON FA.IDAngajat=C.IDDoctor
	GROUP BY C.IDDoctor,P.Nume,P.Prenume,C.Observatii
)
SELECT ID, Angajati.Nume AS [Nume Doctor], Angajati.Prenume AS [Prenume Doctor],[Nume Pacient],[Prenume Pacient],Diagnostic
FROM DiagnosticCTE
INNER JOIN Angajati ON Angajati.IDAngajat=ID

GO
SELECT * FROM [Diagnostic Pacienti]

--67. Creati un view cu materialele achizitionate de la fiecare furnizor.

GO
IF OBJECT_ID('Materiale furnizate','V') is not null
	DROP VIEW [Materiale furnizate]
GO
CREATE VIEW [Materiale furnizate]
AS
	SELECT Materiale.Denumire AS [Denumire Material],Furnizori.Nume AS [Nume Furnizor], Furnizori.Adresa AS [Adresa Furnizor]
	FROM Materiale
	INNER JOIN [Materiale Furnizori] ON [Materiale Furnizori].IDMaterial=Materiale.IDMaterial
	INNER JOIN Furnizori ON Furnizori.IDFurnizor=[Materiale Furnizori].IDFurnizor
	GROUP BY Materiale.Denumire ,Furnizori.Nume , Furnizori.Adresa 
	
GO
SELECT * FROM [Materiale furnizate]

--68. Creati un view cu toti angajatii, functiile lor curente si departamentele in care lucreaza.

GO
IF OBJECT_ID('Functii Curente Angajati','V') is not null
	DROP VIEW [Functii Curente Angajati]
GO
CREATE VIEW [Functii Curente Angajati]
AS
	SELECT A.IDAngajat,A.Nume, A.Prenume, F.Denumire AS [Functie], D.Denumire AS [Departament]
	FROM Angajati AS A
	INNER JOIN [Functii Angajati] AS FA ON FA.IDAngajat=A.IDAngajat
	INNER JOIN Functii AS F ON F.IDFunctie=FA.IDFunctie
	INNER JOIN [Departamente Angajati] AS DA ON DA.IDAngajat=A.IDAngajat
	INNER JOIN Departamente AS D ON D.IDDepartament=DA.IDDepartament
	WHERE FA.[Data final] IS NULL

GO
SELECT * FROM [Functii Curente Angajati]

--69. Creati un view cu toti angajatii, si cu toate functiile pe care le-a avut pana in prezent.

GO
IF OBJECT_ID('Istoric Angajati','V') is not null
	DROP VIEW [Istoric Angajati]
GO
CREATE VIEW [Istoric Angajati]
AS
	SELECT FA.IDAngajat,A.Nume, A.Prenume,F.Denumire AS Functie,FA.[Data început], FA.[Data final]
	FROM Angajati AS A
	INNER JOIN [Functii Angajati] AS FA ON FA.IDAngajat=A.IDAngajat
	INNER JOIN Functii AS F ON F.IDFunctie=FA.IDFunctie

GO
SELECT * FROM [Istoric Angajati]

--70. Creati un view cu istoricul pacientilor internati.

GO
IF OBJECT_ID('Istoric Pacienti','V') is not null
	DROP VIEW [Istoric Pacienti]
GO
CREATE VIEW [Istoric Pacienti]
AS
	SELECT P.Nume,P.Prenume,I.[Data Internare],I.Diagnostic,E.[Data Externare],E.[Raport Evaluare]
	FROM Pacienti AS P
	INNER JOIN Externari AS E ON E.IDPacient=P.IDPacient
	INNER JOIN Programari AS PR ON PR.IDPacient=P.IDPacient
	INNER JOIN Consultatii AS C ON C.IDProgramare=PR.IDProgramare
	INNER JOIN Internari AS I ON I.IDConsultatie=C.IDConsultatie

GO
SELECT * FROM [Istoric Pacienti]


-----------------------------CTE------------------------------

--71. Selectati impozitele totale ale tuturor angajatilor.

GO
WITH ImpoziteCTE AS
(
	SELECT [Impozite Angajati].IDAngajat AS ID,SUM(Impozite.Procent) AS [Impozit Total]
	FROM Impozite
	INNER JOIN [Impozite Angajati] ON [Impozite Angajati].IDImpozit=Impozite.IDImpozit
	INNER JOIN Angajati ON Angajati.IDAngajat=[Impozite Angajati].IDImpozit
	GROUP BY [Impozite Angajati].IDAngajat
)
SELECT ID, Angajati.Nume,Angajati.Prenume, [Impozit Total] FROM ImpoziteCTE
INNER JOIN Angajati ON Angajati.IDAngajat = ID

--72. Selectati pretul total din facturile pacientilor militari, tinand cont ca acestia au 20% reducere din asigurare.

GO
WITH PretCTE AS
(
	SELECT P.IDPacient AS ID,FP.ModPlata AS [Mod Plata], (CP.Pret*20)/100 AS [Pret Redus],CP.Pret AS [Pret Total] 
	FROM [Consultatie Proceduri] AS CP
	INNER JOIN Consultatii AS C ON C.IDConsultatie=CP.IDConsultatie
	INNER JOIN Programari AS PR ON PR.IDProgramare=C.IDProgramare
	INNER JOIN Pacienti AS P ON P.IDPacient=PR.IDPacient
	INNER JOIN [Factura pacient] AS FP ON FP.IDConsultatieProceduri=CP.IDConsultatieProceduri
	WHERE P.[este Militar]='DA'
)
SELECT ID, Pacienti.Nume, Pacienti.Prenume, Pacienti.[este Militar],[Mod Plata],[Pret Redus],[Pret Total]
FROM PretCTE
INNER JOIN Pacienti ON Pacienti.IDPacient = ID

--73. Selectati diagnosticul formulat de catre doctori pentru fiecare pacient.

GO
WITH DiagnosticCTE AS
(
	SELECT C.IDDoctor AS ID, P.Nume AS [Nume Pacient], P.Prenume AS [Prenume Pacient],C.Observatii AS Diagnostic
	FROM Consultatii AS C
	INNER JOIN Programari AS PR ON PR.IDProgramare=C.IDProgramare
	INNER JOIN Pacienti AS P ON P.IDPacient=PR.IDPacient
	INNER JOIN [Functii Angajati] AS FA ON FA.IDAngajat=C.IDDoctor
	GROUP BY C.IDDoctor,P.Nume,P.Prenume,C.Observatii
)
SELECT ID, Angajati.Nume AS [Nume Doctor], Angajati.Prenume AS [Prenume Doctor],[Nume Pacient],[Prenume Pacient],Diagnostic
FROM DiagnosticCTE
INNER JOIN Angajati ON Angajati.IDAngajat=ID

--74. Selectati angajatii spitalului, ordonati dupa departamentele din care fac parte.

GO
WITH AngajatiCTE AS
(
	SELECT Departamente.IDDepartament AS ID, Angajati.Nume, Angajati.Prenume
	FROM Angajati 
	INNER JOIN [Departamente Angajati] ON [Departamente Angajati].IDAngajat=Angajati.IDAngajat
	INNER JOIN Departamente ON Departamente.IDDepartament=[Departamente Angajati].IDDepartament
	GROUP BY Departamente.IDDepartament,Angajati.Nume, Angajati.Prenume
)
SELECT *
FROM AngajatiCTE

--75. Selectati pacientii care au fost consultati de angajatul cu id-ul 6

GO
WITH PacientiCTE AS
(
	SELECT Pacienti.IDPacient AS ID, Pacienti.Nume, Pacienti.Prenume
	FROM Pacienti 
)
SELECT Nume,Prenume
FROM PacientiCTE
INNER JOIN Programari AS PR ON PR.IDPacient=ID
INNER JOIN Consultatii AS C ON C.IDProgramare=PR.IDProgramare
WHERE C.IDDoctor=6


-------------------------------UPDATE-URI-----------------------------------

--76. Mariti salariul brut de la functiile curente ale angajatilor care au fost promovati cu 500 de lei.

SELECT * FROM Functii

UPDATE Functii
SET [Salariu brut]+=500
FROM [Functii Angajati]
INNER JOIN Functii ON Functii.IDFunctie=[Functii Angajati].IDFunctie
INNER JOIN Angajati ON Angajati.IDAngajat=[Functii Angajati].IDAngajat
WHERE  [Functii Angajati].IDAngajat IN (SELECT IDAngajat
    FROM [Functii Angajati]
    GROUP BY IDAngajat
    HAVING COUNT(*) > 1) and [Functii Angajati].[Data final] is null

SELECT * FROM Functii

--77. Modificati urgenta programarilor pacientilor care au fost externati.

SELECT * FROM Programari

UPDATE Programari
SET [este Urgenta]='NU'
FROM Programari
INNER JOIN Pacienti ON Pacienti.IDPacient=Programari.IDPacient
INNER JOIN Externari ON Externari.IDPacient=Pacienti.IDPacient
WHERE [este Urgenta]='DA'

SELECT * FROM Programari

--78. Modificati modul de plata 'CARD' pacientilor carora le-a fost emisa factura.

SELECT * FROM [Factura pacient]

UPDATE FP
SET FP.ModPlata='CASH'
FROM [Factura pacient] AS FP
INNER JOIN [Consultatie Proceduri] AS CP ON CP.IDConsultatieProceduri=FP.IDConsultatieProceduri
INNER JOIN Consultatii AS C ON C.IDConsultatie=CP.IDConsultatie
INNER JOIN Programari AS PR ON PR.IDProgramare=C.IDProgramare
INNER JOIN Pacienti AS P ON P.IDPacient=PR.IDPacient
WHERE FP.ModPlata='CARD'

SELECT * FROM [Factura pacient]

--79. Adaugati o adresa de email angajatilor care nu si-au trecut adresa de mail.

SELECT * FROM Angajati

UPDATE Angajati
SET Email = 'admin@yahoo.com'
FROM Angajati
WHERE Angajati.Email is NULL

SELECT * FROM Angajati

--80. Scumpiti cu 30 de lei pretul consultatiilor care folosesc materiale furnizate de ThreePharm.

SELECT * FROM [Consultatie Proceduri]

UPDATE CP
SET CP.Pret+=30
FROM [Consultatie Proceduri] AS CP
INNER JOIN [Materiale Procedura] AS MP ON MP.IDMaterialeProcedura=CP.IDMaterialeProcedura
INNER JOIN Materiale AS M ON M.IDMaterial=MP.IDMaterial
INNER JOIN [Materiale Furnizori] AS MF ON MF.IDMaterial=M.IDMaterial
INNER JOIN Furnizori AS F ON F.IDFurnizor=MF.IDFurnizor
WHERE F.Nume = 'ThreePharm'

SELECT * FROM [Consultatie Proceduri]

--81. Faceti gratuite consultatiile pacientilor militari.

SELECT * FROM [Consultatie Proceduri]

UPDATE CP
SET CP.Pret=0
FROM [Consultatie Proceduri] AS CP
INNER JOIN Consultatii AS C ON C.IDConsultatie=CP.IDConsultatie
INNER JOIN Programari AS PR ON PR.IDProgramare=C.IDProgramare
INNER JOIN Pacienti AS P ON P.IDPacient=PR.IDPacient
WHERE P.[este Militar] = 'DA'

SELECT * FROM [Consultatie Proceduri]

--82. Concediati angajatul cu functia de farmacist.

SELECT * FROM [Functii Angajati]

UPDATE [Functii Angajati]
SET [Data final]=GETDATE()
FROM [Functii Angajati]
INNER JOIN Functii ON Functii.IDFunctie=[Functii Angajati].IDFunctie
WHERE Functii.Denumire='Farmacist'

SELECT * FROM [Functii Angajati]

--83. Furnizorul TIMEX-FARM SRL si-a schimbat adresa pe Strada Capitan Mircea Vasilescu nr. 26. Actualizati informatiile.

SELECT * FROM Furnizori

UPDATE Furnizori
SET Adresa = 'Strada Capitan Mircea Vasilescu nr. 26'
FROM Furnizori
WHERE Furnizori.Nume = 'TIMEX-FARM SRL'

SELECT * FROM Furnizori

--84. Scadeti greutatea pacientilor care au fost internati cu 5kg.

SELECT * FROM Pacienti

UPDATE Pacienti
SET Greutate-=5
FROM Pacienti
INNER JOIN Programari ON Programari.IDPacient=Pacienti.IDPacient
INNER JOIN Consultatii ON Consultatii.IDProgramare=Programari.IDProgramare
INNER JOIN Internari ON Internari.IDConsultatie=Consultatii.IDConsultatie

SELECT * FROM Pacienti

--85. Schimbati ultima cifra din numarul de telefon al pacientului caruia ii e recomandat in urma procedurii regim alimentar.

SELECT * FROM Pacienti

UPDATE Pacienti
SET NrTelefon = '0741603407'
FROM Pacienti
INNER JOIN Programari ON Programari.IDPacient=Pacienti.IDPacient
INNER JOIN Consultatii ON Consultatii.IDProgramare=Programari.IDProgramare
INNER JOIN Internari ON Internari.IDConsultatie=Consultatii.IDConsultatie
WHERE Internari.Diagnostic LIKE '%regim alimentar%'

SELECT * FROM Pacienti

--86. Schimbati numele furnizorului TIMEX-FARM SRL in TIMEX FARM.

SELECT * FROM Furnizori

UPDATE Furnizori
SET Nume = 'TIMEX FARM'
FROM Furnizori
WHERE Furnizori.Nume = 'TIMEX-FARM SRL'

SELECT * FROM Furnizori

--87. Schimbati numele categoriei de materiale pt proceduri chirurgicale in Instrumente chirurgicale.

SELECT * FROM [Categorii Materiale]

UPDATE [Categorii Materiale]
SET Denumire='Instrumente chirurgicale'
FROM [Categorii Materiale]
INNER JOIN Materiale ON Materiale.IDCategorie=[Categorii Materiale].IDCategorie
INNER JOIN [Materiale Procedura] ON [Materiale Procedura].IDMaterial=Materiale.IDMaterial
INNER JOIN Proceduri ON Proceduri.IDProcedura=[Materiale Procedura].IDProcedura
WHERE Proceduri.Denumire='Proceduri chirurgicale' AND [Categorii Materiale].Denumire LIKE '%chirurgical%'

SELECT * FROM [Categorii Materiale]

--88.Pacientul Avram Mara si-a schimbat programarea din data de 2022-08-18 in 2022-08-20.

SELECT * FROM Programari

UPDATE Programari
SET [Data programare]=CAST('2022-08-20' as datetime)
FROM Programari
INNER JOIN Pacienti ON Pacienti.IDPacient=Programari.IDPacient
WHERE Pacienti.Nume='Avram' AND Pacienti.Prenume='Mara'

SELECT * FROM Programari

--89. Schimbati numele pacientului Popa in 'Pop'.

SELECT * FROM Pacienti

UPDATE Pacienti
SET Nume='Pop'
FROM Pacienti
WHERE Pacienti.Nume='Popa'

SELECT * FROM Pacienti

--90. Schimbati ultima cifra din numerele de telefon in 0 ale angajatilor care se afla in reteaua Orange.

SELECT * FROM Angajati

UPDATE Angajati
SET Telefon = LEFT(Telefon, LEN(Telefon) - 1)+'0'
WHERE Telefon LIKE '074%' OR Telefon LIKE '075%'

SELECT *FROM Angajati


---------------------------PROCEDURI STOCATE------------------------------

--91.Creati o procedura stocata care afișează informatii despre toti angajatii care au început sa lucreze dupa o anumită data.

IF OBJECT_ID('AngajatiDupaDataIncepere', 'P') IS NOT NULL 
	DROP PROC AngajatiDupaDataIncepere; 
GO
CREATE PROC AngajatiDupaDataIncepere
    @DataIncepere DATETIME
AS
BEGIN
    SELECT A.Nume, A.Prenume, FA.[Data început]
    FROM Angajati A
    INNER JOIN [Functii Angajati] AS FA ON A.IDAngajat = FA.IDAngajat
    WHERE FA.[Data început] > @DataIncepere AND FA.[Data final] IS NULL
END

GO
EXEC AngajatiDupaDataIncepere '2016-03-07'


--92. Creati o procedura care sa afiseze toti angajatii care au o anumita functie.

IF OBJECT_ID('AngajatiDupaFunctie', 'P') IS NOT NULL 
	DROP PROC AngajatiDupaFunctie; 
GO
CREATE PROC AngajatiDupaFunctie
    @numeFunc NVARCHAR(40)
AS
BEGIN
    SELECT A.Nume, A.Prenume, F.Denumire
    FROM Angajati A
    INNER JOIN [Functii Angajati] AS FA ON A.IDAngajat = FA.IDAngajat
	INNER JOIN Functii AS F ON F.IDFunctie=FA.IDFunctie
    WHERE F.Denumire=@numeFunc
END

GO
EXEC AngajatiDupaFunctie 'Medic Specialist'

--93. Creati o procedura care sa returneze salariul net unui angajat in functi de nume si prenume.

IF OBJECT_ID('SalariuDupaAngajat', 'P') IS NOT NULL 
	DROP PROC SalariuDupaAngajat; 
GO
CREATE PROC SalariuDupaAngajat
    @nume NVARCHAR(20),
	@prenume NVARCHAR(20),
	@salariu FLOAT output
AS
BEGIN
    SELECT @salariu=[Salariu net].[Salariu NET]
	FROM [Salariu net]
	WHERE Nume=@nume AND Prenume=@prenume
	RETURN;
END

DECLARE @out FLOAT
EXECUTE SalariuDupaAngajat
		@nume = 'Mihai',
		@prenume = 'Ana',
		@salariu=@out OUTPUT
SELECT @out AS SalariuNet

--94. Creati o procedura stocata pentru a adauga prenumele x tuturor angajatilor cu prenumele y.

IF OBJECT_ID('AdaugaPrenumeAngajati', 'P') IS NOT NULL 
	DROP PROC AdaugaPrenumeAngajati; 
GO
CREATE PROC AdaugaPrenumeAngajati
    @x NVARCHAR(20),
	@y NVARCHAR(20)
AS
BEGIN
    UPDATE Angajati
	SET Angajati.Prenume=Angajati.Prenume +'-'+ @x
	FROM Angajati
	WHERE Angajati.Prenume=@y
END

SELECT Angajati.Nume, Angajati.Prenume FROM Angajati
EXEC AdaugaPrenumeAngajati 'Eliza','Ioana'
SELECT Angajati.Nume, Angajati.Prenume FROM Angajati

--95. Creati o procedura care sa afiseze programarile intre data x si y.

IF OBJECT_ID('ProgramariDupaData', 'P') IS NOT NULL
	DROP PROC ProgramariDupaData
GO
CREATE PROC ProgramariDupaData
	@x DATE,
	@y DATE
AS 
BEGIN
	SELECT IDProgramare,[Data programare]
	FROM Programari
	WHERE Programari.[Data programare] >= @x AND
	Programari.[Data programare] < @y
END

GO
EXEC ProgramariDupaData '2023-02-10','2023-04-11'

--96. Creati o procedura care afiseaza numele pacientilor consultati de un anumit angajat.

IF OBJECT_ID('PacientiDupaAngajat', 'P') IS NOT NULL
	DROP PROC PacientiDupaAngajat
GO
CREATE PROC PacientiDupaAngajat
	@id INT
AS 
BEGIN
	IF EXISTS (SELECT * FROM Angajati AS A 
				INNER JOIN [Functii Angajati] AS FA ON FA.IDAngajat=A.IDAngajat
				INNER JOIN Functii AS F ON F.IDFunctie=FA.IDFunctie
				WHERE F.Denumire='Medic Specialist' AND @id=A.IDAngajat)
	BEGIN
		SELECT P.Nume, P.Prenume
		FROM Pacienti AS P
		INNER JOIN Programari AS PR ON P.IDPacient=PR.IDPacient
		INNER JOIN Consultatii AS C ON C.IDProgramare=PR.IDProgramare
		INNER JOIN [Consultatie Proceduri] AS CP ON CP.IDConsultatie=C.IDConsultatie
		WHERE @id=C.IDDoctor
	END
	ELSE
		BEGIN
			--THROW 50000,'Angajatul introdus nu este medic!', 0
			RAISERROR('Angajatul introdus nu este medic!',16,1)
		END
END

GO
EXEC PacientiDupaAngajat 2

--97. Creati o procedura stocata care afiseaza cate programari au fost in fiecare luna a anului x.

IF OBJECT_ID('ProgramariLunarePeAn', 'P') is not null
	DROP PROCEDURE ProgramariLunarePeAn
GO
CREATE PROC ProgramariLunarePeAn
	@an INT
AS
BEGIN
	WITH Programari_Lunare AS
	(	
		SELECT MONTH(Programari.[Data programare]) AS Luna, COUNT(*) AS [Numar Programari]
		FROM Programari
		WHERE YEAR(Programari.[Data programare]) = @an
		GROUP BY MONTH(Programari.[Data programare])
	) -- parametru 2: indicele de start pentru extragerea subșirului
	SELECT SUBSTRING('JAN FEB MAR APR MAY JUN JUL AUG SEP OCT NOV DEC', 
	Programari_Lunare.Luna*4-3,3) AS Luna, Programari_Lunare.[Numar Programari]
	FROM Programari_Lunare
	ORDER BY Programari_Lunare.Luna
END

EXEC ProgramariLunarePeAn 2023

--98. Creati o procedura stocata care afiseaza materialele care sunt folosite intr-o anumita procedura.

IF OBJECT_ID('MaterialePerProcedura', 'P') IS NOT NULL
	DROP PROC MaterialePerProcedura
GO
CREATE PROC MaterialePerProcedura
	@procedura NVARCHAR(40)
AS
BEGIN
	SELECT M.Denumire
	FROM Materiale AS M
	INNER JOIN [Materiale Procedura] AS MP ON MP.IDMaterial=M.IDMaterial
	INNER JOIN Proceduri AS P ON P.IDProcedura=MP.IDProcedura
	WHERE P.Denumire=@procedura
END

EXEC MaterialePerProcedura 'Proceduri chirurgicale'

--99.  Creați o procedură stocată care să efectueze o reducere de pret de x% la toate consultatiile care folosesc materiale din categoria y.

IF OBJECT_ID('ReducerePretMateriale', 'P') IS NOT NULL
	DROP PROC ReducerePretMateriale
GO
CREATE PROC ReducerePretMateriale
	@x REAL,
	@categorie NVARCHAR(40)
AS
BEGIN
	UPDATE CP
	SET Pret -= @x * Pret
	FROM [Consultatie Proceduri] AS CP
	INNER JOIN [Materiale Procedura] AS MP ON MP.IDMaterialeProcedura=CP.IDMaterialeProcedura
	INNER JOIN Materiale AS M ON M.IDMaterial=MP.IDMaterial
	INNER JOIN [Categorii Materiale] AS CM ON CM.IDCategorie=M.IDCategorie
	WHERE CM.Denumire=@categorie
END

SELECT * FROM [Consultatie Proceduri]
EXEC ReducerePretMateriale 0.05,'Instrumente chirurgicale'
SELECT * FROM [Consultatie Proceduri]

--100. Creati o procedura stocata care sa afiseze impozitul total al unui angajat.

IF OBJECT_ID('ImpozitTotalPerAngajat', 'P') IS NOT NULL
	DROP PROC ImpozitTotalPerAngajat
GO
CREATE PROC ImpozitTotalPerAngajat
	@id INT
AS
BEGIN
	SELECT Nume,Prenume,[Impozit Total]
	FROM [Impozite Totale]
	WHERE [Impozite Totale].ID = @id
END

EXEC ImpozitTotalPerAngajat 2


--------------------------TRIGGERE-----------------------------

--101.Adauga un trigger pe tabela Departamente care sa afiseze un mesaj la fiecare insert in tabela: 
--"Departamentul [Denumire] a fost adaugat cu succes".

IF OBJECT_ID('tr_Departamente_Insert', 'TR') IS NOT NULL
	DROP TRIGGER tr_Departamente_Insert
GO
CREATE TRIGGER tr_Departamente_Insert 
ON Departamente
AFTER INSERT
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN
	SET NOCOUNT ON;
    DECLARE @msg NVARCHAR(100)
    SELECT @msg = 'Departamentul ' + Denumire + ' a fost adaugat cu succes.' FROM inserted
    PRINT @msg
END

INSERT INTO Departamente(Denumire)
VALUES ('Urgente')

--102. Creati un trigger care sa nu permita inregistrarea aceluiasi angajat.

IF OBJECT_ID('tr_Angajat_Insert', 'TR') IS NOT NULL
	DROP TRIGGER tr_Angajat_Insert;
GO
CREATE TRIGGER tr_Angajat_Insert
ON Angajati
INSTEAD OF INSERT
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN
	SET NOCOUNT ON;
	IF EXISTS (SELECT COUNT(*) FROM inserted
				INNER JOIN Angajati
				on inserted.Telefon = Angajati.Telefon
				group by Angajati.IDAngajat
				HAVING COUNT(*) > = 1)
	BEGIN
		PRINT 'Exista deja acest angajat inregistrat';
	END
	ELSE
		BEGIN
			DECLARE @nume nvarchar(20)
			SELECT @nume=Nume FROM INSERTED

			DECLARE @prenume nvarchar(20)
			SELECT @prenume=Prenume FROM INSERTED

			DECLARE @DataNastere date
			SELECT @DataNastere=[Data Nastere] FROM INSERTED

			DECLARE @adresa nvarchar(100)
			SELECT @adresa=Adresa FROM INSERTED

			DECLARE @telefon varchar(10)
			SELECT @telefon=Telefon FROM INSERTED

			DECLARE @email nvarchar(50)
			SELECT @email=Email FROM INSERTED

			INSERT INTO Angajati(Nume, Prenume, [Data Nastere], Adresa, Telefon, Email)
			values (@nume, @prenume, @DataNastere, @adresa, @telefon, @email)
		END
END


INSERT INTO Angajati(Nume, Prenume, [Data Nastere], Adresa, Telefon, Email)
values
('Popovici','Victor','1987-10-18','Strada Grigore Manolescu 14','0723332098','popoVictor2@yaoo.com')
SELECT * FROM Angajati

--103. Creati un trigger care sa afiseze un mesaj dupa ce un angajat isi inceteaza activitatea.

IF OBJECT_ID('tr_Angajat_Demisie', 'TR') IS NOT NULL
	DROP TRIGGER tr_Angajat_Demisie;
GO
CREATE TRIGGER tr_Angajat_Demisie
ON [Functii Angajati]
AFTER UPDATE
AS 
BEGIN
	IF @@ROWCOUNT = 0 RETURN
	SET NOCOUNT ON;
	IF (UPDATE([Data final]))
	PRINT 'Iti multumim pentru munca depusa in cadrul spitalului!'
END


GO
UPDATE [Functii Angajati]
SET [Data final]='2021-01-15'
WHERE [Functii Angajati].IDAngajat=6 AND [Functii Angajati].IDFunctie=2

--104. Creati un trigger care sa afiseze un mesaj cand se externeaza un pacient.

IF OBJECT_ID('tr_Pacient_Externat', 'TR') IS NOT NULL
	DROP TRIGGER tr_Pacient_Externat;
GO
CREATE TRIGGER tr_Pacient_Externat
ON Externari
AFTER INSERT
AS 
BEGIN
	IF @@ROWCOUNT = 0 RETURN
	SET NOCOUNT ON;
    DECLARE @msg NVARCHAR(100)
    SELECT @msg = 'Starea de sanatate a pacientului s-a imbunatatit semnificativ in timpul sederii sale la spital!' FROM inserted
    PRINT @msg
END

GO
select * from Externari
INSERT INTO Externari(IDPacient,[Data Externare],[Raport Evaluare])
VALUES (5,'2023-05-03','Regim alimentar inca 2 luni')
select * from Externari

--105. Să se creeze un trigger care sa nu permita inserarea sau modificarea numelui unui material într-un nume de material deja înregistrat.

IF OBJECT_ID('tr_Material_Modificare', 'TR') IS NOT NULL
	DROP TRIGGER tr_Material_Modificare;
GO
CREATE TRIGGER tr_Material_Modificare
on Materiale
AFTER INSERT, UPDATE
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;
	IF EXISTS (SELECT COUNT(*) FROM inserted
				JOIN Materiale ON inserted.Denumire = Materiale.Denumire
				GROUP BY inserted.Denumire
				HAVING COUNT(*) > 1 )
	BEGIN
		RAISERROR('Acest material exista deja!',16,1)
		ROLLBACK
	END
END

INSERT INTO Materiale(Denumire, IDCategorie)
values
('Masti de protectie',5)
select * from Materiale

--106. Creați un trigger care să nu permită duplicarea furnizorilor.

IF OBJECT_ID('tr_Furnizor_Insert', 'TR') IS NOT NULL
	DROP TRIGGER tr_Furnizor_Insert;
GO
CREATE TRIGGER tr_Furnizor_Insert
ON Furnizori
AFTER INSERT, UPDATE
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;
	IF EXISTS (SELECT COUNT(*)
				FROM Inserted AS I 
				INNER JOIN Furnizori AS F ON I.Nume = F.Nume
				GROUP BY I.Nume
				HAVING COUNT(*) > 1 )
	BEGIN
		PRINT 'Duplicate provider names not allowed';
		ROLLBACK
	END
END

INSERT INTO Furnizori(Nume,Adresa,Telefon)
VALUES ('SMART MEDICAL','Calea Victoriei','0755602964')

--107. Creati un trigger care sa afiseze un mesaj dupa orice modificare din tabela Categorii Materiale.

IF OBJECT_ID('tr_CategoriiMateriale_Modificare', 'TR') IS NOT NULL
	DROP TRIGGER tr_CategoriiMateriale_Modificare;
GO
CREATE TRIGGER tr_CategoriiMateriale_Modificare
ON [Categorii Materiale]
AFTER DELETE,INSERT,UPDATE
AS
BEGIN
	PRINT('S-a modificat ceva in tabela Categorii Materiale')
END

GO
INSERT INTO [Categorii Materiale](Denumire)
VALUES('Materiale administrative')
SELECT * FROM [Categorii Materiale]

--108. Creati un trigger care sa afiseze un mesaj de eroare la stergerea unei retete.

IF OBJECT_ID('tr_Reteta_Stergere', 'TR') IS NOT NULL
	DROP TRIGGER tr_Reteta_Stergere;
GO
CREATE TRIGGER tr_Reteta_Stergere
ON Reteta
FOR DELETE
AS
BEGIN
	RAISERROR('RETETA STEARSA',16,1)
	ROLLBACK
END

GO
DELETE
FROM Reteta
WHERE Reteta.IDReteta=1

--109.Creati un trigger cu o restrictie la pretul minim a unei proceduri.

IF OBJECT_ID('tr_Pret_Minim','tr') IS NOT NULL
	DROP TRIGGER tr_Pret_Minim
GO
CREATE TRIGGER tr_Pret_Minim
ON [Consultatie Proceduri]
FOR INSERT,DELETE
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;
	DECLARE @pret INT
	SELECT @pret=I.Pret from inserted as I
	IF(@pret < 150)
	BEGIN
		RAISERROR('Pretul de %d este mai mic decat valoarea minima(150 RON)',16,1,@pret)
		ROLLBACK
	END
END

INSERT INTO [Consultatie Proceduri](IDConsultatie,IDMaterialeProcedura,Pret)
VALUES(2,1,100)


--110.Creati un trigger pentru ștergerea unei funcții pe care există angajați.

IF OBJECT_ID('tr_Functie_Angajat','tr') IS NOT NULL
	DROP TRIGGER tr_Functie_Angajat
GO
CREATE TRIGGER tr_Functie_Angajat
ON Functii
INSTEAD OF DELETE
AS
BEGIN
	IF @@ROWCOUNT = 0 RETURN;
	SET NOCOUNT ON;
	DECLARE @IDFunctie INT
	SELECT @IDFunctie=D.IDFunctie
	FROM deleted AS D
	IF EXISTS( SELECT F.IDFunctie, F.Denumire, FA.IDAngajat
				FROM Functii AS F
				INNER JOIN [Functii Angajati] as FA on FA.IDFunctie=F.IDFunctie
				WHERE FA.IDAngajat IS NOT NULL AND F.IDFunctie=@IDFunctie)
	BEGIN
		RAISERROR('Functia selectata spre stergere are angajati asignati!',16,1)
		ROLLBACK 
	END
END

DELETE F
FROM Functii AS F
WHERE F.Denumire='Farmacist'

--111. Creati un view care sa afiseze toate materialele din fiecare categorie.

IF OBJECT_ID('MaterialePerCategorie','V') IS NOT NULL
	DROP VIEW MaterialePerCategorie 
GO
CREATE VIEW MaterialePerCategorie
AS
	SELECT [Categorii Materiale].Denumire AS CATEGORIE,Materiale.Denumire AS MATERIAL
	FROM Materiale 
	INNER JOIN [Categorii Materiale] ON [Categorii Materiale].IDCategorie=Materiale.IDCategorie
	GROUP BY [Categorii Materiale].Denumire,Materiale.Denumire

GO
SELECT * FROM MaterialePerCategorie

--112. Creati un view care sa afiseze toate functiile avute de fiecare angajat.

IF OBJECT_ID('FunctiiPerAngajat','V') IS NOT NULL
	DROP VIEW FunctiiPerAngajat 
GO
CREATE VIEW FunctiiPerAngajat
AS
	SELECT A.IDAngajat,A.Nume,A.Prenume,F.Denumire,FA.[Data început],FA.[Data final]
	FROM Functii AS F 
	INNER JOIN [Functii Angajati] AS FA ON F.IDFunctie=FA.IDFunctie
	INNER JOIN Angajati AS A ON A.IDAngajat=FA.IDAngajat
	GROUP BY A.IDAngajat,A.Nume,A.Prenume,FA.[Data început],FA.[Data final],F.Denumire

GO
SELECT * FROM FunctiiPerAngajat

--113. Creati o procedura stocata care sa afiseze functia curenta a unui angajat.

IF OBJECT_ID('FunctieCurentaAngajat', 'P') IS NOT NULL
	DROP PROC FunctieCurentaAngajat
GO
CREATE PROC FunctieCurentaAngajat
	@idAng INT
AS
BEGIN
	SELECT Nume,Prenume,Functie,Departament
	FROM [Functii Curente Angajati]
	WHERE [Functii Curente Angajati].IDAngajat = @idAng
END

EXEC FunctieCurentaAngajat 3

--114. Creati o procedura stocata care sa afiseze diagnosticul unui pacient dupa nume si prenume.

IF OBJECT_ID('DiagnosticPacient', 'P') IS NOT NULL
	DROP PROC DiagnosticPacient
GO
CREATE PROC DiagnosticPacient
	@nume NVARCHAR(20),
	@prenume NVARCHAR(20),
	@diagnostic NVARCHAR(50) OUTPUT
AS
BEGIN
	SELECT Diagnostic
	FROM [Diagnostic Pacienti]
	WHERE [Nume Pacient]=@nume AND [Prenume Pacient]=@prenume
	RETURN;
END

DECLARE @out NVARCHAR(50)
EXECUTE DiagnosticPacient
		@nume = 'Calinescu',
		@prenume = 'Marina',
		@diagnostic=@out OUTPUT

--115. Creati o procedura stocata care sa afiseze doctorul care a executat procedura unui pacient dat.

IF OBJECT_ID('DoctorProcPacient', 'P') IS NOT NULL
	DROP PROC DoctorProcPacient
GO
CREATE PROC DoctorProcPacient
	@nume NVARCHAR(20),
	@prenume NVARCHAR(20),
	@doctor NVARCHAR(50) OUTPUT
AS
BEGIN
	SELECT CONCAT([Nume Angajat],' ',[Prenume Angajat]) as Medic
	FROM [Proceduri pacienti]
	WHERE [Nume Pacient]=@nume AND [Prenume Pacient]=@prenume
	RETURN;
END

DECLARE @out NVARCHAR(50)
EXECUTE DoctorProcPacient
		@nume = 'Avram',
		@prenume = 'Mara',
		@doctor=@out OUTPUT

select * from [Proceduri pacienti]

--116. Creati un trigger pentru inserarea in view-ul MaterialePerCategorie.

IF OBJECT_ID('TR_MaterialePerCategorie_insert','TR') is not null
	DROP TRIGGER TR_MaterialePerCategorie_insert
GO
CREATE TRIGGER TR_MaterialePerCategorie_insert
ON MaterialePerCategorie
INSTEAD OF INSERT
AS
BEGIN
	IF @@ROWCOUNT=0 RETURN
	SET NOCOUNT ON

	INSERT INTO [Categorii Materiale](Denumire)
		SELECT CATEGORIE
		FROM inserted

	DECLARE @IDCategorie INT
	SELECT @IDCategorie = [Categorii Materiale].IDCategorie
	FROM [Categorii Materiale]
	INNER JOIN inserted ON inserted.CATEGORIE=[Categorii Materiale].Denumire
	WHERE Denumire=inserted.CATEGORIE
	
	INSERT INTO Materiale(IDCategorie,Denumire)
	SELECT @IDCategorie,(SELECT MATERIAL
		FROM inserted)

	PRINT('Categories and materials inserted!')
END

INSERT INTO MaterialePerCategorie
VALUES('Materiale laborator','Agitator probe')

select * from [Categorii Materiale]
select * from Materiale
select * from MaterialePerCategorie

--117. Creati un trigger pentru stergerea din view-ul MaterialePerCategorie.

IF OBJECT_ID('TR_MaterialePerCategorie_delete','TR') is not null
	DROP TRIGGER TR_MaterialePerCategorie_delete
GO
CREATE TRIGGER TR_MaterialePerCategorie_delete
ON MaterialePerCategorie
INSTEAD OF DELETE
AS
BEGIN
	IF @@ROWCOUNT=0 RETURN
	SET NOCOUNT ON

	DELETE FROM [Categorii Materiale]
	WHERE [Categorii Materiale].Denumire=(SELECT CATEGORIE FROM deleted)

	DELETE FROM Materiale
	WHERE Materiale.Denumire=(SELECT MATERIAL FROM deleted)

	PRINT('Categories and materials DELETED!')
END

DELETE FROM MaterialePerCategorie
WHERE CATEGORIE='Materiale sanitare' AND MATERIAL='Pansament'

select * from [Categorii Materiale]
select * from Materiale
select * from MaterialePerCategorie


----------------------------------TRANZACTII---------------------------------


--118. Sa se creeze o tranzactie care sa verifice daca exista o anumita persoana in baza de date.

BEGIN TRAN
	SELECT Nume,Prenume FROM Angajati
	WHERE Nume LIKE 'Mihai' AND Prenume LIKE 'Ana'
	UNION ALL
	SELECT Nume, Prenume FROM Pacienti
	WHERE Nume LIKE 'Mihai' AND Prenume LIKE 'Ana'
	IF @@ROWCOUNT = 0
	BEGIN
		PRINT 'Persoana nu exista in baza de date. '
		ROLLBACK TRAN;
	END
	ELSE
	BEGIN
		PRINT 'Aceasta persoana exista in baza de date'
		COMMIT TRAN;
	END


--119. Sa se creeze o tranzactie care sa verifice daca exista o anumita procedura in cadrul spitalului.

BEGIN TRAN
	SELECT * FROM Proceduri
	WHERE Proceduri.Denumire = 'Ecografie'
	IF @@ROWCOUNT = 0
	BEGIN
		PRINT 'Nu exista acest serviciu in baza de date '
		ROLLBACK TRAN;
	END
	ELSE
	BEGIN
		PRINT 'Aceast serviciu exista in baza de date'
		COMMIT TRAN;
	END


--120. Sa se creeze o tranzactie care sa verifice inserarea unei proceduri in tabela Proceduri.

BEGIN TRY
BEGIN TRAN
	SET IDENTITY_INSERT Proceduri ON;
	INSERT INTO Proceduri(IDProcedura,Denumire,IDDoctor)
	VALUES(2,'Ecografie',3);
	SET IDENTITY_INSERT Proceduri OFF;
	COMMIT TRAN;
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS ErrorNumber
	IF ERROR_NUMBER() = 2627 -- Duplicate key violation
	BEGIN
		PRINT 'Primary Key violation';
	END
	ELSE IF ERROR_NUMBER() = 547 -- Constraint violations
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END;
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH;

--121. Sa se creeze o tranzactie care sa verifice inserarea unui angajat, cat si impozitele si functiile sale.

DECLARE @errnum AS INT;
BEGIN TRAN 
	BEGIN TRAN
	SET IDENTITY_INSERT Angajati ON;
	INSERT INTO Angajati(IDAngajat,Nume,Prenume,[Data nastere],Adresa,Telefon, Email)
	VALUES (10,'Chirila','George','1985-11-04','Strada Viilor nr5','0741863976','gchirila@gmail.com')
	SET IDENTITY_INSERT Angajati OFF;
	COMMIT TRAN;
	BEGIN TRAN
		INSERT INTO [Impozite Angajati](IDImpozit,IDAngajat)
		VALUES(1,10),(2,10),(3,10)
	COMMIT TRAN
	BEGIN TRAN
		INSERT INTO [Functii Angajati](IDFunctie,IDAngajat,[Data început],[Data final])
		VALUES(3,10,'2023-01-01',NULL)
	COMMIT TRAN
	SET @errnum = @@ERROR
	IF @errnum <> 0

	BEGIN
		PRINT 'Inserare esuata cu cod: ' + CAST(@errnum as varchar);
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		COMMIT TRAN
	END;
	

--122. Sa se creeze o tranzactie in care se adauga un furnizor si un material de la acel furnizor.

BEGIN TRY
	SELECT @@TRANCOUNT
	BEGIN TRAN
		BEGIN TRAN
			SELECT * FROM Furnizori
			SET IDENTITY_INSERT Furnizori ON;
			INSERT INTO Furnizori(IDFurnizor,Nume,Adresa,Telefon)
			VALUES(4,'Biotehnos','Strada Buzesti 71-73 sector 1','0765254344')
			SET IDENTITY_INSERT Furnizori OFF;
		COMMIT TRAN;

		SET IDENTITY_INSERT Materiale ON;
		INSERT INTO Materiale(IDMaterial,Denumire,IDCategorie)
		VALUES(20,'Pansamente',3)
		SET IDENTITY_INSERT Materiale OFF;

		INSERT INTO [Materiale Furnizori](IDMaterial,IDFurnizor)
		VALUES (20,4)

		SELECT * FROM Furnizori
	COMMIT TRAN;
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 --error for duplicate key violation
	BEGIN
		PRINT 'Primary key violation';
	END
	ELSE IF ERROR_NUMBER() = 547 --constraint violations
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN;
END CATCH;

--123. Sa se creeze o tranzactie in care se adauga bonus salar 200 RON celor nascuti inainte de 1990.
GO
DECLARE @errnum AS INT;
BEGIN TRAN
	UPDATE Functii
	SET [Salariu brut] = [Salariu brut] + 200
	FROM Functii
	inner join [Functii Angajati] on Functii.IDFunctie=[Functii Angajati].IDFunctie
	inner join Angajati on Angajati.IDAngajat=[Functii Angajati].IDAngajat
	WHERE DATEPART(YEAR,Angajati.[Data nastere])<1990
	SET @errnum = @@ERROR
	IF @errnum <> 0
	BEGIN
		PRINT 'Cresterea salariilor a esuat cu eroare: ' + CAST(@errnum as varchar);
		ROLLBACK TRAN;
	END
	ELSE
	BEGIN
		COMMIT TRAN;
	END;

--124. Sa se creeze o tranzactie care la stergerea unui material, in cazul in care apare o eroare, sa-l redenumeasca in schimb.
go
DECLARE @errnum AS INT;
BEGIN TRAN 
	DELETE FROM Materiale
	WHERE Materiale.Denumire LIKE 'Pansamente'
	SET @errnum=@@ERROR
	IF @errnum<>0
	BEGIN
		PRINT 'Nu se poate sterge materialul Pansamente'
		ROLLBACK TRAN;
	BEGIN TRAN
		UPDATE Materiale
		SET Materiale.Denumire = 'Material'
		WHERE Materiale.Denumire LIKE 'Pansamente'
	COMMIT TRAN;
	END;
	ELSE
	BEGIN
		PRINT 'S-a sters materialul Pansamente'
	COMMIT TRAN;
END;

--125. Sa se creeze  o tranzactie in care se verifica inserarea in tabela de legatura Materiale Furnizori.

BEGIN TRY
BEGIN TRAN;
	INSERT INTO [Materiale Furnizori](IDMaterial, IDFurnizor)
	VALUES(25,3);
	COMMIT TRAN;
END TRY
BEGIN CATCH
	SELECT ERROR_MESSAGE() AS ErrorNumber
	IF ERROR_NUMBER() = 547 
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END;
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
END CATCH;

select * from [Materiale Furnizori]

--126.Sa se creeze o tranzactie care la stergerea unui pacient(dupa ID) sa afiseze factura acestuia, daca a beneficiat de serivicii in spital.
GO
DECLARE @errnum AS INT;
BEGIN TRAN

	DELETE Pacienti FROM Pacienti
	WHERE Pacienti.IDPacient=5

	SELECT Pret
	FROM [Consultatie Proceduri]
	INNER JOIN Consultatii ON [Consultatie Proceduri].IDConsultatie=Consultatii.IDConsultatie
	INNER JOIN Programari ON Consultatii.IDProgramare=Programari.IDProgramare
	INNER JOIN Pacienti ON Programari.IDPacient=Pacienti.IDPacient
	WHERE Pacienti.IDPacient=6

	SET @errnum=@@ERROR
	IF @errnum<>0
	BEGIN
		PRINT 'Nu se poate sterge pacientul cu id-ul 6'
		ROLLBACK TRAN;
	END;
	ELSE
	BEGIN
		PRINT 'S-a sters pacientul cu id-ul 6'
		COMMIT TRAN;
	END


	select* from Programari
	select * from Consultatii
	select * from [Consultatie Proceduri]
	select * from [Factura pacient]

--127.Sa se creeze o tranzactie in care se adauga un departament nou spitalului, i se modifica numele si se sterge.

BEGIN TRY
	SELECT @@TRANCOUNT
	SELECT @@ERROR
BEGIN TRAN
	SELECT * FROM Departamente

	INSERT INTO Departamente(Denumire)
	VALUES('Urgente')

	UPDATE Departamente
	SET Denumire='Urgente de grad1'
	WHERE Denumire='Urgente'

	SELECT * FROM Departamente

	DELETE from Departamente
	WHERE Denumire='Urgente de grad1'

	SELECT * FROM Departamente
	COMMIT TRAN
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 
	BEGIN
		PRINT 'Primary key violation';
	END
	ELSE IF ERROR_NUMBER() = 547
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN;
	END CATCH;

--128. Sa se creeze o tranzactie in care se modifica data unei programari o luna mai tarziu, si se modifica doctorul consultatiei corespunzatoare.

BEGIN TRY
	SELECT @@TRANCOUNT
	SELECT @@ERROR
BEGIN TRAN
	SELECT * FROM Programari

	DECLARE @dataNoua AS DATE= '2023-05-01' 

	UPDATE Programari
	SET [Data programare]=@dataNoua
	WHERE [Data programare]='2023-04-01'

	SELECT * FROM Programari
	SELECT * FROM Consultatii

	UPDATE Consultatii
	SET IDDoctor = 2
	FROM Consultatii
	INNER JOIN Programari ON Programari.IDProgramare=Consultatii.IDProgramare
	WHERE Programari.[Data programare]=@dataNoua

	SELECT * FROM Consultatii

	COMMIT TRAN
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 
	BEGIN
		PRINT 'Primary key violation';
	END
	ELSE IF ERROR_NUMBER() = 547
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN;
	END CATCH;


--129. Sa se creeze o tranzactie care sa programeze o consultatie urgenta pacientului cu id-ul 4.

BEGIN TRY
	SELECT @@TRANCOUNT
	SELECT @@ERROR
	BEGIN TRAN
		SELECT * FROM Programari

		DECLARE @idAng AS INT
		SELECT @idAng = Angajati.IDAngajat
		FROM Angajati
		INNER JOIN [Functii Angajati] ON [Functii Angajati].IDAngajat=Angajati.IDAngajat
		INNER JOIN Functii ON Functii.IDFunctie=[Functii Angajati].IDFunctie
		WHERE Functii.Denumire='Receptionist'

		SET IDENTITY_INSERT Programari ON;
		INSERT INTO Programari(IDProgramare,IDPacient,IDReceptionist,[Data programare],[este Urgenta])
		VALUES(100,4,@idAng,'2023-05-13','DA');
		SET IDENTITY_INSERT Programari OFF;

		SELECT * FROM Programari

	COMMIT TRAN;
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 --error for duplicate key violation
	BEGIN
		PRINT 'Primary key violation';
	END
	ELSE IF ERROR_NUMBER() = 547 --constraint violations
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN;
END CATCH;

--130. Sa se creeze o tranzactie care sa adauge monitoare in cadrul procedurii de dializa.

BEGIN TRY
	SELECT @@TRANCOUNT
	SELECT @@ERROR
	BEGIN TRAN
		SELECT * FROM [Materiale Procedura]

		DECLARE @idProcedura AS INT
		SELECT @idProcedura = Proceduri.IDProcedura
		FROM Proceduri
		WHERE Proceduri.Denumire='Dializa'

		DECLARE @idMaterial AS INT
		SELECT @idMaterial = Materiale.IDMaterial
		FROM Materiale
		WHERE Materiale.Denumire='Monitoare'

		INSERT INTO [Materiale Procedura](IDMaterial,IDProcedura)
		VALUES(@idMaterial,@idProcedura);
	
		SELECT @idMaterial as Material
		SELECT @idProcedura as Procedura
		SELECT * FROM [Materiale Procedura]

	COMMIT TRAN;
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 --error for duplicate key violation
	BEGIN
		PRINT 'Primary key violation';
	END
	ELSE IF ERROR_NUMBER() = 547 --constraint violations
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN;
END CATCH;

--131. Sa se creeze o tranzactie care sa adauge o factura pacientului cu id-ul 2, iar apoi sa fie stearsa.

BEGIN TRY
	SELECT @@TRANCOUNT
	SELECT @@ERROR
BEGIN TRAN
	SELECT * FROM [Factura pacient]

	INSERT INTO [Factura pacient](IDConsultatieProceduri,ModPlata)
	VALUES(2,'CARD')

	SELECT * FROM [Factura pacient]

	DELETE from [Factura pacient]
	WHERE IDFactura=(SELECT TOP 1 IDFactura
						FROM [Factura pacient]
						ORDER BY IDFactura DESC)
	
	SELECT * FROM [Factura pacient]

	COMMIT TRAN
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 
	BEGIN
		PRINT 'Primary key violation';
	END
	ELSE IF ERROR_NUMBER() = 547
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN;
END CATCH;

--132. Sa se creeze o tranzactie care sa externeze un pacient, iar daca acesta nu a fost niciodata internat, sa se stearga inregistrarea.

BEGIN TRY
	SELECT @@TRANCOUNT
	SELECT @@ERROR
	BEGIN TRAN 
		DECLARE @idExt AS INT
		SET @idExt=4

		BEGIN TRAN
			SELECT * FROM Externari

			INSERT INTO Externari(IDPacient,[Data Externare],[Raport Evaluare])
			VALUES(@idExt,'2023-05-13','Raport Evaluare')

			SELECT * FROM Externari
		COMMIT TRAN;
		IF EXISTS (SELECT Pacienti.IDPacient FROM Pacienti
					INNER JOIN Externari ON Pacienti.IDPacient=Externari.IDPacient
					INNER JOIN Programari ON Programari.IDPacient=Pacienti.IDPacient
					INNER JOIN Consultatii ON Programari.IDProgramare=Consultatii.IDProgramare
					INNER JOIN Internari ON Internari.IDConsultatie=Consultatii.IDConsultatie
					WHERE Externari.IDPacient=@idExt)
		BEGIN
			PRINT 'Externare efectuata cu succes!';
		END;
		ELSE
		BEGIN
			DELETE from Externari
			WHERE IDExternare=(SELECT TOP 1 IDExternare
						FROM Externari
						ORDER BY IDExternare DESC)

			SELECT * FROM Externari
		END;
	COMMIT TRAN;
END TRY
BEGIN CATCH
	IF ERROR_NUMBER() = 2627 
	BEGIN
		PRINT 'Primary key violation';
	END
	ELSE IF ERROR_NUMBER() = 547
	BEGIN
		PRINT 'Constraint violation';
	END
	ELSE
	BEGIN
		PRINT 'Unhandled error';
	END
	IF @@TRANCOUNT > 0
		ROLLBACK TRAN;
END CATCH;

--133. Afisati toti pacientii externati din spital.

SELECT IDPacient,[Data Externare]
FROM Externari

--134. Afisati toti pacientii internati in spital.

SELECT P.IDPacient,I.[Data Internare]
FROM Pacienti AS P
INNER JOIN Programari AS PR ON PR.IDPacient=P.IDPacient
INNER JOIN Consultatii AS C ON C.IDProgramare=PR.IDProgramare
INNER JOIN Internari AS I ON I.IDConsultatie=C.IDConsultatie

--135. Afisati toti pacientii care au fost internati in spital, dar si externati.

SELECT P.IDPacient,I.[Data Internare],E.[Data Externare]
FROM Pacienti AS P
INNER JOIN Externari AS E ON E.IDPacient=P.IDPacient
INNER JOIN Programari AS PR ON PR.IDPacient=P.IDPacient
INNER JOIN Consultatii AS C ON C.IDProgramare=PR.IDProgramare
INNER JOIN Internari AS I ON I.IDConsultatie=C.IDConsultatie



------------------------DELETE-URI-----------------------------

SELECT * 
FROM sys.foreign_keys 
WHERE name = 'FK_MatProc2'

--136. Sa se stearga toate materialele furnizate de TIMEX FARM.
 
ALTER TABLE [Consultatie Proceduri]
DROP CONSTRAINT [FK_MatProc2]

ALTER TABLE [Consultatie Proceduri] WITH CHECK
ADD CONSTRAINT [FK_MatProc2] FOREIGN KEY(IDMaterialeProcedura)
REFERENCES [Materiale Procedura] (IDMaterialeProcedura)
ON DELETE NO ACTION

ALTER TABLE [Materiale Procedura]
DROP CONSTRAINT [FK_IDMaterial1]

ALTER TABLE [Materiale Procedura] WITH CHECK
ADD CONSTRAINT [FK_IDMaterial1] FOREIGN KEY(IDMaterial) 
REFERENCES Materiale(IDMaterial) 
ON DELETE CASCADE

ALTER TABLE [Materiale Furnizori]
DROP CONSTRAINT [FK_IDMaterial2]

ALTER TABLE [Materiale Furnizori] WITH CHECK
ADD CONSTRAINT [FK_IDMaterial2] FOREIGN KEY(IDMaterial) 
REFERENCES Materiale(IDMaterial) 
ON DELETE CASCADE

SELECT DISTINCT Materiale.*
FROM Materiale
INNER JOIN [Materiale Furnizori] ON Materiale.IDMaterial=[Materiale Furnizori].IDMaterial
INNER JOIN Furnizori ON Furnizori.IDFurnizor=[Materiale Furnizori].IDFurnizor
WHERE Furnizori.Nume = 'TIMEX FARM'

SELECT * FROM Materiale

DELETE Materiale
FROM Materiale 
INNER JOIN [Materiale Furnizori] ON Materiale.IDMaterial=[Materiale Furnizori].IDMaterial
INNER JOIN Furnizori ON Furnizori.IDFurnizor=[Materiale Furnizori].IDFurnizor
WHERE Furnizori.Nume = 'TIMEX FARM'

SELECT * FROM Materiale


--137. Sa se stearga angajatii care au functia de Personal Administrativ in cadrul spitalului.

ALTER TABLE [Functii Angajati]
DROP CONSTRAINT [FK_IDAngajat2]

ALTER TABLE [Functii Angajati] WITH CHECK
ADD CONSTRAINT [FK_IDAngajat2] FOREIGN KEY(IDAngajat)
REFERENCES Angajati (IDAngajat)
ON DELETE CASCADE

SELECT DISTINCT Angajati.*
FROM Angajati
INNER JOIN [Functii Angajati] ON [Functii Angajati].IDAngajat=Angajati.IDAngajat
INNER JOIN Functii ON Functii.IDFunctie=[Functii Angajati].IDFunctie
WHERE Functii.Denumire = 'Personal Administrativ'

SELECT * FROM Angajati

DELETE Angajati
FROM Angajati
INNER JOIN [Functii Angajati] ON [Functii Angajati].IDAngajat=Angajati.IDAngajat
INNER JOIN Functii ON Functii.IDFunctie=[Functii Angajati].IDFunctie
WHERE Functii.Denumire = 'Personal Administrativ'

SELECT * FROM Angajati

--138. Sa se stearga cel mai batran pacient.

select * from Pacienti

DECLARE @varstaPacient AS INT
SET @varstaPacient = (SELECT TOP 1 MAX (YEAR(GETDATE()) - YEAR(Pacienti.[Data Nastere])) FROM Pacienti)

DELETE Pacienti FROM Pacienti
WHERE @varstaPacient = YEAR (GETDATE()) - YEAR(Pacienti.[Data Nastere])

select * from Pacienti


SELECT * 
FROM sys.foreign_keys 
WHERE name = 'FK_MatProc2'

--139. Sa se stearga departamentele care au mai mult de 2 angajati.

ALTER TABLE [Departamente Angajati]
DROP CONSTRAINT [FK_IDDepart]

ALTER TABLE [Departamente Angajati] WITH CHECK
ADD CONSTRAINT [FK_IDDepart] FOREIGN KEY(IDDepartament)
REFERENCES Departamente (IDDepartament)
ON DELETE CASCADE

SELECT Departamente.IDDepartament,Departamente.Denumire
FROM Departamente
INNER JOIN [Departamente Angajati] ON [Departamente Angajati].IDDepartament=Departamente.IDDepartament
INNER JOIN Angajati ON Angajati.IDAngajat=[Departamente Angajati].IDAngajat
GROUP BY Departamente.IDDepartament,Departamente.Denumire
HAVING COUNT(*) >= 2

SELECT * FROM Departamente

DELETE FROM Departamente
WHERE IDDepartament IN (
  SELECT IDDepartament
  FROM [Departamente Angajati]
  GROUP BY IDDepartament
  HAVING COUNT(*) >= 2
)

SELECT * FROM Departamente

 --140. Sa se stearga angajatii care nu mai lucreaza in spital.

ALTER TABLE [Functii Angajati]
DROP CONSTRAINT [FK_IDAngajat2]

ALTER TABLE [Functii Angajati] WITH CHECK
ADD CONSTRAINT [FK_IDAngajat2] FOREIGN KEY(IDAngajat)
REFERENCES Angajati (IDAngajat)
ON DELETE CASCADE

SELECT *
FROM [Functii Angajati]

SELECT * FROM Angajati

DELETE Angajati
FROM Angajati
WHERE IDAngajat IN (
	SELECT IDAngajat
	FROM [Functii Angajati]
	WHERE [Data final] IS NOT NULL
)
AND IDAngajat NOT IN (
	SELECT IDAngajat
	FROM [Functii Angajati]
	WHERE [Data final] IS NULL
)

SELECT * FROM Angajati

 --141. Sa se stearga programarile pacientilor externati.

ALTER TABLE Programari
DROP CONSTRAINT [FK_PacientProg]

ALTER TABLE Programari WITH CHECK
ADD CONSTRAINT [FK_PacientProg] FOREIGN KEY(IDPacient) 
REFERENCES Pacienti(IDPacient) 
ON DELETE CASCADE

SELECT Programari.IDProgramare,Pacienti.Nume,Pacienti.Prenume,Externari.[Data Externare]
FROM Programari
INNER JOIN Pacienti ON Pacienti.IDPacient=Programari.IDPacient
INNER JOIN Externari ON Externari.IDPacient=Pacienti.IDPacient

SELECT * FROM Programari

DELETE Programari
FROM Programari
WHERE IDProgramare IN(
	SELECT Programari.IDProgramare
	FROM Programari
	INNER JOIN Pacienti ON Pacienti.IDPacient=Programari.IDPacient
	INNER JOIN Externari ON Externari.IDPacient=Pacienti.IDPacient
	)

SELECT * FROM Programari


--142. Sa se stearga consultatiile ale caror programari sunt facute de angajatul cu functia de receptionist cu id-ul 8.

ALTER TABLE Consultatii
DROP CONSTRAINT [FK_Programare]

ALTER TABLE Consultatii WITH CHECK
ADD CONSTRAINT [FK_Programare] FOREIGN KEY(IDProgramare) 
REFERENCES Programari(IDProgramare) 
ON DELETE CASCADE

ALTER TABLE Consultatii
DROP CONSTRAINT [FK_DoctorConsult]

ALTER TABLE Consultatii WITH CHECK 
ADD CONSTRAINT [FK_DoctorConsult] FOREIGN KEY(IDDoctor) 
REFERENCES [Functii Angajati](IDFunctAng)
ON DELETE NO ACTION

SELECT Consultatii.IDConsultatie
FROM Consultatii
INNER JOIN Programari ON Programari.IDProgramare=Consultatii.IDProgramare
INNER JOIN [Functii Angajati] ON [Functii Angajati].IDAngajat=Programari.IDReceptionist
WHERE Programari.IDReceptionist = 8

SELECT * FROM Consultatii

DELETE Consultatii
FROM Consultatii
WHERE IDProgramare IN(
	SELECT Consultatii.IDConsultatie
	FROM Consultatii
	INNER JOIN Programari ON Programari.IDProgramare=Consultatii.IDProgramare
	INNER JOIN [Functii Angajati] ON [Functii Angajati].IDAngajat=Programari.IDReceptionist
	WHERE Programari.IDReceptionist = 8
	)

SELECT * FROM Consultatii

--143. Sa se stearga categoriile de materiale cu cele mai putine materiale.

ALTER TABLE Materiale
DROP CONSTRAINT [FK_IDCategorie]

ALTER TABLE Materiale WITH CHECK
ADD CONSTRAINT [FK_IDCategorie] FOREIGN KEY(IDCategorie) 
REFERENCES [Categorii Materiale](IDCategorie) 
ON DELETE CASCADE

SELECT *
FROM [Categorii Materiale]
WHERE IDCategorie IN (
    SELECT IDCategorie
    FROM Materiale
    GROUP BY IDCategorie
    HAVING COUNT(*) = (
        SELECT MIN(cnt)
        FROM (
            SELECT COUNT(*) AS cnt
            FROM Materiale
            GROUP BY IDCategorie
        ) t
    )
);

SELECT * FROM [Categorii Materiale]

DELETE [Categorii Materiale]
FROM [Categorii Materiale]
WHERE IDCategorie IN (
    SELECT IDCategorie
    FROM Materiale
    GROUP BY IDCategorie
    HAVING COUNT(*) = (
        SELECT MIN(cnt)
        FROM (
            SELECT COUNT(*) AS cnt
            FROM Materiale
            GROUP BY IDCategorie
        ) t
    )
);

SELECT * FROM [Categorii Materiale]

--144. Sa se stearga cea mai scumpa factura.

SELECT * FROM [Factura pacient]

DELETE FROM [Factura pacient]
WHERE IDFactura = 
    (SELECT TOP 1 IDFactura
     FROM [Factura pacient]
     INNER JOIN [Consultatie Proceduri] 
	 ON [Factura pacient].IDConsultatieProceduri = [Consultatie Proceduri].IDConsultatieProceduri
     ORDER BY [Consultatie Proceduri].Pret DESC)


SELECT * FROM [Factura pacient]

--145. Sa se stearga programarea urgenta.

select * from Programari

DELETE 
FROM Programari
WHERE [este Urgenta]='DA'

--146.Sa se stearga toti pacientii consultati de angajatul Popescu Maria-Elena. (Crihana Dragos)

ALTER TABLE Programari
DROP CONSTRAINT FK_PacientProg

ALTER TABLE Programari
ADD CONSTRAINT FK_PacientProg FOREIGN KEY(IDPacient) 
REFERENCES Pacienti(IDPacient) 
ON DELETE CASCADE

ALTER TABLE Consultatii
DROP CONSTRAINT [FK_Programare]

ALTER TABLE Consultatii WITH CHECK
ADD CONSTRAINT [FK_Programare] FOREIGN KEY(IDProgramare) 
REFERENCES Programari(IDProgramare) 
ON DELETE CASCADE

ALTER TABLE Consultatii
DROP CONSTRAINT [FK_DoctorConsult]

ALTER TABLE Consultatii WITH CHECK 
ADD CONSTRAINT [FK_DoctorConsult] FOREIGN KEY(IDDoctor) 
REFERENCES [Functii Angajati](IDFunctAng)
ON DELETE NO ACTION

SELECT DISTINCT Pacienti.*
FROM Pacienti
INNER JOIN Programari ON Programari.IDPacient=Pacienti.IDPacient
INNER JOIN Consultatii ON Consultatii.IDProgramare=Programari.IDProgramare
INNER JOIN [Functii Angajati] ON [Functii Angajati].IDAngajat=Consultatii.IDDoctor
INNER JOIN Angajati ON Angajati.IDAngajat=[Functii Angajati].IDAngajat
WHERE Angajati.Nume='Popescu' AND Angajati.Prenume='Maria-Elena'

SELECT * FROM Pacienti

DELETE FROM Pacienti
WHERE IDPacient IN (
    SELECT DISTINCT Programari.IDPacient
    FROM Programari
    INNER JOIN Consultatii ON Consultatii.IDProgramare = Programari.IDProgramare
    INNER JOIN [Functii Angajati] ON [Functii Angajati].IDAngajat = Consultatii.IDDoctor
    INNER JOIN Angajati ON Angajati.IDAngajat = [Functii Angajati].IDAngajat
    WHERE Angajati.Nume = 'Popescu' AND Angajati.Prenume = 'Maria-Elena'
)

SELECT * FROM Pacienti

--147. Sa se stearga ultima reteta emisa din tabelul cu retete.

SELECT * FROM Reteta

DELETE FROM Reteta
WHERE IDReteta IN (
  SELECT TOP 1 IDReteta
  FROM Reteta
  ORDER BY IDReteta DESC
);


SELECT * FROM Reteta

--148. Sa se stearga toate programările care au avut loc înainte de 1 ianuarie 2022.

SELECT * FROM Programari

DELETE FROM Programari
WHERE [Data programare] < '2022-01-01';

SELECT * FROM Programari

--149. Sa se stearga cel mai tanar pacient.

SELECT * FROM Pacienti

DECLARE @tanarPacient AS INT
SET @tanarPacient = (SELECT TOP 1 MIN (YEAR(GETDATE()) - YEAR(Pacienti.[Data Nastere])) FROM Pacienti)

DELETE Pacienti FROM Pacienti
WHERE @tanarPacient = YEAR (GETDATE()) - YEAR(Pacienti.[Data Nastere])

SELECT * FROM Pacienti

--150. Sa se stearga toate datele din tabela Internari pentru pacienții care au fost externați acum mai mult de 30 de zile.

ALTER TABLE Consultatii
DROP CONSTRAINT [FK_Programare]

ALTER TABLE Consultatii WITH CHECK
ADD CONSTRAINT [FK_Programare] FOREIGN KEY(IDProgramare) 
REFERENCES Programari(IDProgramare) 
ON DELETE CASCADE

SELECT * FROM Externari
SELECT * FROM Internari

DELETE FROM Internari
WHERE IDInternare IN 
(
	SELECT I.IDInternare
	FROM Internari I
	INNER JOIN Consultatii C ON I.IDConsultatie = C.IDConsultatie
	INNER JOIN Programari P ON C.IDConsultatie = P.IDProgramare
	INNER JOIN Pacienti Pa ON P.IDPacient = Pa.IDPacient
	INNER JOIN Externari E ON E.IDPacient=Pa.IDPacient
	WHERE DATEDIFF(day, E.[Data Externare], GETDATE()) > 30
)

SELECT * FROM Internari

select * from [Salariu net]

GO
WITH Angajat_ranking AS
(
	SELECT [Salariu net].Nume,[Salariu net].Prenume,Departamente.Denumire AS Departament,[Salariu NET],RANK() OVER (PARTITION BY Departamente.Denumire ORDER BY [Salariu NET] DESC) AS ranking
	FROM Angajati
	INNER JOIN [Salariu net] ON [Salariu net].IDAngajat=Angajati.IDAngajat
	INNER JOIN [Departamente Angajati] ON [Departamente Angajati].IDAngajat=Angajati.IDAngajat
	INNER JOIN Departamente ON Departamente.IDDepartament=[Departamente Angajati].IDDepartament
)
SELECT Departament,Nume,Prenume,[Salariu NET]
FROM Angajat_ranking
WHERE ranking = 2
ORDER BY Departament,Nume