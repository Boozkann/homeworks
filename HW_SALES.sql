SELECT * FROM CUSTOMERS

--1. Customers isimli bir veritabaný oluþturunuz ve içerisine verilen excel dosyasýný tablo olarak ekleyin.
-- IMPORT-EXPORT WIZARD ILE EKLENDI

--2. Customers tablosundan adý ‘A’ harfi ile baþlayan kiþileri çeken sorguyu yazýnýz.------------------------

SELECT *
FROM CUSTOMERS
WHERE NAMESURNAME LIKE 'A%'

--3. 1990 ve 1995 yýllarý arasýnda doðan müþterileri çekiniz. 1990 ve 1995 yýllarý dahildir.------------------------

SELECT *
FROM CUSTOMERS
WHERE BIRTHDATE BETWEEN '1990-01-01' AND '1995-12-31'
ORDER BY BIRTHDATE

--YA DA 

SELECT *
FROM Customers
WHERE YEAR(BIRTHDATE) BETWEEN 1990 AND 1995
ORDER BY BIRTHDATE

--4. Ýstanbul’da yaþayan kiþileri Join kullanarak getiren sorguyu yazýnýz.----------------------------

SELECT
CT.CITY,
C.NAMESURNAME,
C.TCNUMBER

FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
WHERE CT.CITY = 'ÝSTANBUL'


SELECT C.*
FROM CUSTOMERS C
JOIN CITIES CT ON C.CITYID = CT.ID
WHERE CT.CITY = 'Ýstanbul'

SELECT CITY, 
COUNT(*) AS KacKez -- DUPLICATE OLMUS (2 KEZ GELIYOR)
FROM CITIES
WHERE CITY = 'Ýstanbul'
GROUP BY CITY

--5. Ýstanbul’da yaþayan kiþileri subquery kullanarak getiren sorguyu yazýnýz.----------------------

SELECT *
FROM CUSTOMERS
WHERE CITYID IN (SELECT ID FROM CITIES WHERE CITY = 'Ýstanbul') 

--6. Hangi þehirde kaç müþterimizin olduðu bilgisini getiren sorguyu yazýnýz.------------------------

SELECT
	CT.CITY,
	COUNT(DISTINCT C.NAMESURNAME) MUSTERISAYISI  -- TEKIL SAYI GELDÝ
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

--7. 10’dan fazla müþterimiz olan þehirleri müþteri sayýsý ile birlikte müþteri sayýsýna göre fazladan aza doðru sýralý þekilde getiriniz.

SELECT
CT.CITY, 
COUNT(C.TCNUMBER) MUSTERISAYISI

FROM CITIES CT
JOIN CUSTOMERS C ON CT.ID = C.CITYID
GROUP BY CT.CITY
HAVING COUNT(C.TCNUMBER) > 10
ORDER BY MUSTERISAYISI DESC



--8. Hangi þehirde kaç erkek, kaç kadýn müþterimizin olduðu bilgisini getiren sorguyu yazýnýz.

SELECT
CT.CITY SEHIR,
SUM(CASE WHEN C.GENDER = 'K' THEN 1 ELSE 0 END) KADIN,
SUM(CASE WHEN C.GENDER = 'E' THEN 1 ELSE 0 END) ERKEK

FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
GROUP BY CT.CITY
ORDER BY CT.CITY



--9. Customers tablosuna yaþ grubu için yeni bir alan ekleyiniz. Bu iþlemi hem management studio ile hem de sql kodu ile yapýnýz. Alaný adý AGEGROUP veritipi Varchar(50)

ALTER TABLE CUSTOMERS
ADD AGEGROUP VARCHAR(50);

--10. Customers tablosuna eklediðiniz AGEGROUP alanýný 20-35 yaþ arasý,36-45 yaþ arasý,46-55 yaþ arasý,55-65 yaþ arasý ve 65 yaþ üstü olarak güncelleyiniz.



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

-- AGE alanýný bugün tarihine göre doldurunuz.

UPDATE CUSTOMERS
SET AGE = DATEDIFF(YEAR, BIRTHDATE, GETDATE())

SELECT * FROM CUSTOMERS
ORDER BY AGE


--11. Ýstanbul’da yaþayýp ilçesi ‘Kadýköy’ dýþýnda olanlarý listeleyiniz.s

-----Dar kapsamlý çözüm

SELECT * FROM DISTRICTS
WHERE CITYID = '34' AND
DISTRICT <> 'Kadýköy'

-----Join'le çözüm


SELECT    ----En baþa distinct koyulabilir ama sonuçlarýný diðer satýrlardaki veriler ve maliyet açýsýndan deðerlendirmek lazým.
  C.*, 
  CT.CITY, 
  D.DISTRICT
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
JOIN DISTRICTS D ON D.ID = C.DISTRICTID
WHERE CT.CITY = 'Ýstanbul' AND D.DISTRICT <> 'Kadýköy'



--12. Müþterilerimizin telefon numalarýnýn operatör bilgisini getirmek istiyoruz. TELNR1 ve TELNR2 alanlarýnýn yanýna
--operatör numarasýný (532),(505) gibi getirmek istiyoruz. Bu sorgu için gereken SQL cümlesini yazýnýz.


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



--13. Müþterilerimizin telefon numaralarýnýn operatör bilgisini getirmek istiyoruz. Örneðin telefon numaralarý “50”
--ya da “55” ile baþlayan “X” operatörü “54” ile baþlayan “Y” operatörü “53” ile baþlayan “Z” operatörü olsun.


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

--Burada hangi operatörden ne kadar müþterimiz olduðu bilgisini getirecek sorguyu yazýnýz.

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

----------Derste alternatif çözüm

SELECT
	CASE
		WHEN LEFT(TELNR1, 3) IN ('(50', '(55') THEN 'X OPR'
		WHEN LEFT(TELNR1, 3) = '(54' THEN 'Y OPR'
		WHEN LEFT(TELNR1, 3) = '(53' THEN 'Z OPR'
		ELSE 'DÝÐER OPR'
	END AS OPERATOR,
	COUNT(*) AS MUSTERISAYISI
FROM CUSTOMERS
WHERE TELNR1 IS NOT NULL
GROUP BY
	CASE
		WHEN LEFT(TELNR1, 3) IN ('(50', '(55') THEN 'X OPR'
		WHEN LEFT(TELNR1, 3) = '(54' THEN 'Y OPR'
		WHEN LEFT(TELNR1, 3) = '(53' THEN 'Z OPR'
		ELSE 'DÝÐER OPR'
	END

--14. Her ilde en çok müþteriye sahip olduðumuz ilçeleri müþteri sayýsýna göre çoktan aza doðru sýralý þekilde þekildeki gibi getirmek için gereken sorguyu yazýnýz.

SELECT
	CT.CITY, 
	D.DISTRICT,
	COUNT(DISTINCT TCNUMBER) AS MUSTERI_SAYISI
FROM CUSTOMERS C
JOIN CITIES CT ON CT.ID = C.CITYID
JOIN DISTRICTS D ON D.ID = C.DISTRICTID
GROUP BY CT.CITY, D.DISTRICT
ORDER BY CT.CITY, MUSTERI_SAYISI DESC


--15. Müþterilerin doðum günlerini haftanýn günü(Pazartesi, Salý, Çarþamba..) olarak getiren sorguyu yazýnýz.

SELECT *,
	DATENAME(WEEKDAY, BIRTHDATE) DOGUMGUNU

FROM CUSTOMERS
	WHERE BIRTHDATE IS NOT NULL
