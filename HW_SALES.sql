SELECT * FROM CUSTOMERS

--1. Customers isimli bir veritaban� olu�turunuz ve i�erisine verilen excel dosyas�n� tablo olarak ekleyin.
-- IMPORT-EXPORT WIZARD ILE EKLENDI

--2. Customers tablosundan ad� �A� harfi ile ba�layan ki�ileri �eken sorguyu yaz�n�z.------------------------

SELECT *
FROM CUSTOMERS
WHERE NAMESURNAME LIKE 'A%'

--3. 1990 ve 1995 y�llar� aras�nda do�an m��terileri �ekiniz. 1990 ve 1995 y�llar� dahildir.------------------------

SELECT *
FROM CUSTOMERS
WHERE BIRTHDATE BETWEEN '1990-01-01' AND '1995-12-31'
ORDER BY BIRTHDATE

--YA DA 

SELECT *
FROM Customers
WHERE YEAR(BIRTHDATE) BETWEEN 1990 AND 1995
ORDER BY BIRTHDATE

--4. �stanbul�da ya�ayan ki�ileri Join kullanarak getiren sorguyu yaz�n�z.----------------------------

SELECT
CT.CITY,
C.NAMESURNAME,
C.TCNUMBER

FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
WHERE CT.CITY = '�STANBUL'


SELECT C.*
FROM CUSTOMERS C
JOIN CITIES CT ON C.CITYID = CT.ID
WHERE CT.CITY = '�stanbul'

SELECT CITY, 
COUNT(*) AS KacKez -- DUPLICATE OLMUS (2 KEZ GELIYOR)
FROM CITIES
WHERE CITY = '�stanbul'
GROUP BY CITY

--5. �stanbul�da ya�ayan ki�ileri subquery kullanarak getiren sorguyu yaz�n�z.----------------------

SELECT *
FROM CUSTOMERS
WHERE CITYID IN (SELECT ID FROM CITIES WHERE CITY = '�stanbul') 

--6. Hangi �ehirde ka� m��terimizin oldu�u bilgisini getiren sorguyu yaz�n�z.------------------------

SELECT
	CT.CITY,
	COUNT(DISTINCT C.NAMESURNAME) MUSTERISAYISI  -- TEKIL SAYI GELD�
FROM
	CUSTOMERS C
	JOIN CITIES CT ON CT.ID = C.CITYID
GROUP BY
	CT.CITY
ORDER BY
	MUSTERISAYISI DESC

----------------1'DEN FAZLA OLANLARI GETIREN SORGU

SELECT DISTINCT
	NAMESURNAME
FROM
	CUSTOMERS

SELECT
	NAMESURNAME,   ---1 'DEN FAZLA OLAN 
	COUNT(*) AS TEKRAR
FROM
	CUSTOMERS
GROUP BY
	NAMESURNAME
HAVING
	COUNT(*) > 1

--7. 10�dan fazla m��terimiz olan �ehirleri m��teri say�s� ile birlikte m��teri say�s�na g�re fazladan aza do�ru s�ral� �ekilde getiriniz.

SELECT
CT.CITY, 
COUNT(C.TCNUMBER) MUSTERISAYISI

FROM CITIES CT
JOIN CUSTOMERS C ON CT.ID = C.CITYID
GROUP BY CT.CITY
HAVING COUNT(C.TCNUMBER) > 10
ORDER BY MUSTERISAYISI DESC



--8. Hangi �ehirde ka� erkek, ka� kad�n m��terimizin oldu�u bilgisini getiren sorguyu yaz�n�z.

SELECT
CT.CITY SEHIR,
SUM(CASE WHEN C.GENDER = 'K' THEN 1 ELSE 0 END) KADIN,
SUM(CASE WHEN C.GENDER = 'E' THEN 1 ELSE 0 END) ERKEK

FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
GROUP BY CT.CITY
ORDER BY CT.CITY



--9. Customers tablosuna ya� grubu i�in yeni bir alan ekleyiniz. Bu i�lemi hem management studio ile hem de sql kodu ile yap�n�z. Alan� ad� AGEGROUP veritipi Varchar(50)

ALTER TABLE CUSTOMERS
ADD AGEGROUP VARCHAR(50);

--10. Customers tablosuna ekledi�iniz AGEGROUP alan�n� 20-35 ya� aras�,36-45 ya� aras�,46-55 ya� aras�,55-65 ya� aras� ve 65 ya� �st� olarak g�ncelleyiniz.



UPDATE CUSTOMERS
SET AGEGROUP = 
  CASE 
    WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 20 AND 35 THEN '20-35'
    WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 36 AND 45 THEN '36-45'
    WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 46 AND 55 THEN '46-55'
	WHEN DATEDIFF(YEAR, BIRTHDATE, GETDATE()) BETWEEN 55 AND 65 THEN '55-65'
	ELSE '65+'
  END

SELECT * FROM CUSTOMERS
ORDER BY AGEGROUP

-- AGE alan�n� bug�n tarihine g�re doldurunuz.

UPDATE CUSTOMERS
SET AGE = DATEDIFF(YEAR, BIRTHDATE, GETDATE())

SELECT * FROM CUSTOMERS
ORDER BY AGE


--11. �stanbul�da ya�ay�p il�esi �Kad�k�y� d���nda olanlar� listeleyiniz.s

-----Dar kapsaml� ��z�m

SELECT * FROM DISTRICTS
WHERE CITYID = '34' AND
DISTRICT <> 'Kad�k�y'

-----Join'le ��z�m


SELECT    ----En ba�a distinct koyulabilir ama sonu�lar�n� di�er sat�rlardaki veriler ve maliyet a��s�ndan de�erlendirmek laz�m.
  C.*, 
  CT.CITY, 
  D.DISTRICT
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
JOIN DISTRICTS D ON D.ID = C.DISTRICTID
WHERE CT.CITY = '�stanbul' AND D.DISTRICT <> 'Kad�k�y'



--12. M��terilerimizin telefon numalar�n�n operat�r bilgisini getirmek istiyoruz. TELNR1 ve TELNR2 alanlar�n�n yan�na
--operat�r numaras�n� (532),(505) gibi getirmek istiyoruz. Bu sorgu i�in gereken SQL c�mlesini yaz�n�z.


SELECT *,
  CASE 
    WHEN TELNR1 IS NOT NULL THEN CONCAT('', LEFT(TELNR1, 4), ')') 
    ELSE NULL 
  END AS OPRKOD1,

  CASE 
    WHEN TELNR2 IS NOT NULL THEN CONCAT('', LEFT(TELNR2, 4), ')') 
    ELSE NULL 
  END AS OPRKOD2
FROM CUSTOMERS

--- Update kullanarak 


UPDATE CUSTOMERS
SET 
  OPRKOD1 = CASE 
              WHEN TELNR1 IS NOT NULL THEN CONCAT('', LEFT(TELNR1, 3), ')')
              ELSE NULL 
            END,
  OPRKOD2 = CASE 
              WHEN TELNR2 IS NOT NULL THEN CONCAT('', LEFT(TELNR2, 3), ')')
              ELSE NULL 
            END



--13. M��terilerimizin telefon numaralar�n�n operat�r bilgisini getirmek istiyoruz. �rne�in telefon numaralar� �50�
--ya da �55� ile ba�layan �X� operat�r� �54� ile ba�layan �Y� operat�r� �53� ile ba�layan �Z� operat�r� olsun.


SELECT *,
	CASE 
		WHEN TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 'OPRX'
		WHEN TELNR1 LIKE '(54%' THEN 'OPRY'
		WHEN TELNR1 LIKE '(53%' THEN 'OPRZ'
	END AS OPERATOR1,

	CASE 
		WHEN TELNR2 LIKE '(50%' OR TELNR2 LIKE '(55%' THEN 'OPRX'
		WHEN TELNR2 LIKE '(54%' THEN 'OPRY'
		WHEN TELNR2 LIKE '(53%' THEN 'OPRZ'
	END AS OPERATOR2
FROM CUSTOMERS

--Burada hangi operat�rden ne kadar m��terimiz oldu�u bilgisini getirecek sorguyu yaz�n�z.

SELECT 
  OPERATOR1, 
  COUNT(*) AS MUSTERI_SAYISI
FROM (SELECT 
    CASE 
      WHEN TELNR1 LIKE '(50%' OR TELNR1 LIKE '(55%' THEN 'OPRX'
      WHEN TELNR1 LIKE '(54%' THEN 'OPRY'
      WHEN TELNR1 LIKE '(53%' THEN 'OPRZ'
      ELSE NULL
    END AS OPERATOR1
  FROM CUSTOMERS) AS OPERATOR_TEL1
WHERE OPERATOR1 IS NOT NULL
GROUP BY OPERATOR1

----------Derste alternatif ��z�m

SELECT
	CASE
		WHEN LEFT(TELNR1, 3) IN ('(50', '(55') THEN 'X OPR'
		WHEN LEFT(TELNR1, 3) = '(54' THEN 'Y OPR'
		WHEN LEFT(TELNR1, 3) = '(53' THEN 'Z OPR'
		ELSE 'D��ER OPR'
	END AS OPERATOR,
	COUNT(*) AS MUSTERISAYISI
FROM CUSTOMERS
WHERE TELNR1 IS NOT NULL
GROUP BY
	CASE
		WHEN LEFT(TELNR1, 3) IN ('(50', '(55') THEN 'X OPR'
		WHEN LEFT(TELNR1, 3) = '(54' THEN 'Y OPR'
		WHEN LEFT(TELNR1, 3) = '(53' THEN 'Z OPR'
		ELSE 'D��ER OPR'
	END

--14. Her ilde en �ok m��teriye sahip oldu�umuz il�eleri m��teri say�s�na g�re �oktan aza do�ru s�ral� �ekilde �ekildeki gibi getirmek i�in gereken sorguyu yaz�n�z.

SELECT
	CT.CITY, 
	D.DISTRICT,
	COUNT(DISTINCT TCNUMBER) AS MUSTERI_SAYISI
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
JOIN DISTRICTS D ON D.ID = C.DISTRICTID
GROUP BY CT.CITY, D.DISTRICT
ORDER BY CT.CITY, MUSTERI_SAYISI DESC


--15. M��terilerin do�um g�nlerini haftan�n g�n�(Pazartesi, Sal�, �ar�amba..) olarak getiren sorguyu yaz�n�z.

SELECT *,
	DATENAME(WEEKDAY, BIRTHDATE) DOGUMGUNU

FROM CUSTOMERS
	WHERE BIRTHDATE IS NOT NULL
