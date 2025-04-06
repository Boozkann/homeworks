select * from person

--1. T�m �al��anlar�n ad, soyad ve maa� bilgilerini getiren SQL sorgusunu yaz�n�z:

select name_, surname, salary  from person

--2. Sadece kad�n �al��anlar�n (GENDER = 'K') isim, soyisim ve do�um tarihlerini listeleyen bir sorgu yaz�n�z.:

select name_, surname, BIRTHDATE from person
where gender = 'k'

--3. 2017 y�l�ndan sonra i�e giren �al��anlar�n isimlerini ve i�e giri� tarihlerini listele:

select name_, surname, INDATE from person
where INDATE > '2017-01-01'
order by INDATE

--4. Yeni bir �al��an ekle(�rnek: Ali Veli, TC No: 12345678901, Erkek, 1985-12-05 do�umlu, 2022-01-15 tarihinde i�e girdi, Departman: 3, Pozisyon: 40, Maa�: 6000):

INSERT INTO PERSON(TCNUMBER,NAME_,SURNAME,GENDER,BIRTHDATE,INDATE,DEPARTMENTID,POSITIONID,SALARY) VALUES('12345678901','Ali','VELI','E','1985-12-05','2022-01-15','3','40','6000')

select * from person
where name_ = 'ali' and surname = 'VELI'


--5. Ferhat Cinar��n maa��n� 6000 olarak g�ncelle:

UPDATE PERSON SET SALARY = '6000'
WHERE NAME_ = 'Ferhat' and SURNAME = 'CINAR'

select * from person
where name_ = 'FERHAT' and surname = 'CINAR'


--6. Deniz Eravc��y� veri taban�ndan sil:

DELETE FROM PERSON
WHERE name_ = 'DENIZ' and surname = 'ERAVCI'

SELECT * FROM PERSON
WHERE name_ = 'DENIZ' and surname = 'ERAVCI'


--7. Do�um y�l� 1960�tan �nce olan �al��anlar� listele:

SELECT * FROM PERSON
WHERE BIRTHDATE < '01-01-1960'


--8. Do�um tarihi 1960�tan �nce ve maa�� 5000�den y�ksek olan �al��anlar� listele:

SELECT * FROM PERSON
WHERE BIRTHDATE < '01-01-1960' AND SALARY > '5000'
ORDER BY SALARY

--9. Departman ID�si 4 olan veya maa�� 5500�den fazla olan �al��anlar� listele:

SELECT * FROM PERSON
WHERE DEPARTMENTID = '4' AND SALARY > '5000'
ORDER BY SALARY


--10. ��k�� tarihi (OUTDATE) NULL olan �al��anlar�n maa�lar�na %10 zam yap:

UPDATE PERSON SET SALARY = SALARY * 1.1
WHERE OUTDATE IS NULL


--11. 2015�ten �nce i�e giren ve maa�� 5000�den d���k olan �al��anlar� sil:

DELETE FROM PERSON
WHERE YEAR(INDATE) < 2015 AND SALARY < 5000

SELECT * FROM PERSON
WHERE YEAR(INDATE) < 2015 AND SALARY < 5000


--12. Veri setinde ka� farkl� departman oldu�unu listele:

SELECT DISTINCT DEPARTMENTID FROM PERSON

SELECT COUNT(DISTINCT DEPARTMENTID) AS DEP_COUNT FROM PERSON

SELECT COUNT(DISTINCT DEPARTMENTID) FROM PERSON


--13. �al��anlar� maa�lar�na g�re en y�ksekten en d����e s�rala:

SELECT * FROM PERSON
ORDER BY SALARY

--14. En y�ksek maa� alan 5 �al��an� listele:

SELECT TOP 5* FROM PERSON
ORDER BY SALARY DESC
















