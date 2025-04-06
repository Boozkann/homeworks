select * from person

--1. Tüm çalýþanlarýn ad, soyad ve maaþ bilgilerini getiren SQL sorgusunu yazýnýz:

select name_, surname, salary  from person

--2. Sadece kadýn çalýþanlarýn (GENDER = 'K') isim, soyisim ve doðum tarihlerini listeleyen bir sorgu yazýnýz.:

select name_, surname, BIRTHDATE from person
where gender = 'k'

--3. 2017 yýlýndan sonra iþe giren çalýþanlarýn isimlerini ve iþe giriþ tarihlerini listele:

select name_, surname, INDATE from person
where INDATE > '2017-01-01'
order by INDATE

--4. Yeni bir çalýþan ekle(Örnek: Ali Veli, TC No: 12345678901, Erkek, 1985-12-05 doðumlu, 2022-01-15 tarihinde iþe girdi, Departman: 3, Pozisyon: 40, Maaþ: 6000):

INSERT INTO PERSON(TCNUMBER,NAME_,SURNAME,GENDER,BIRTHDATE,INDATE,DEPARTMENTID,POSITIONID,SALARY) VALUES('12345678901','Ali','VELI','E','1985-12-05','2022-01-15','3','40','6000')

select * from person
where name_ = 'ali' and surname = 'VELI'


--5. Ferhat Cinar’ýn maaþýný 6000 olarak güncelle:

UPDATE PERSON SET SALARY = '6000'
WHERE NAME_ = 'Ferhat' and SURNAME = 'CINAR'

select * from person
where name_ = 'FERHAT' and surname = 'CINAR'


--6. Deniz Eravcý’yý veri tabanýndan sil:

DELETE FROM PERSON
WHERE name_ = 'DENIZ' and surname = 'ERAVCI'

SELECT * FROM PERSON
WHERE name_ = 'DENIZ' and surname = 'ERAVCI'


--7. Doðum yýlý 1960’tan önce olan çalýþanlarý listele:

SELECT * FROM PERSON
WHERE BIRTHDATE < '01-01-1960'


--8. Doðum tarihi 1960’tan önce ve maaþý 5000’den yüksek olan çalýþanlarý listele:

SELECT * FROM PERSON
WHERE BIRTHDATE < '01-01-1960' AND SALARY > '5000'
ORDER BY SALARY

--9. Departman ID’si 4 olan veya maaþý 5500’den fazla olan çalýþanlarý listele:

SELECT * FROM PERSON
WHERE DEPARTMENTID = '4' AND SALARY > '5000'
ORDER BY SALARY


--10. Çýkýþ tarihi (OUTDATE) NULL olan çalýþanlarýn maaþlarýna %10 zam yap:

UPDATE PERSON SET SALARY = SALARY * 1.1
WHERE OUTDATE IS NULL


--11. 2015’ten önce iþe giren ve maaþý 5000’den düþük olan çalýþanlarý sil:

DELETE FROM PERSON
WHERE YEAR(INDATE) < 2015 AND SALARY < 5000

SELECT * FROM PERSON
WHERE YEAR(INDATE) < 2015 AND SALARY < 5000


--12. Veri setinde kaç farklý departman olduðunu listele:

SELECT DISTINCT DEPARTMENTID FROM PERSON

SELECT COUNT(DISTINCT DEPARTMENTID) AS DEP_COUNT FROM PERSON

SELECT COUNT(DISTINCT DEPARTMENTID) FROM PERSON


--13. Çalýþanlarý maaþlarýna göre en yüksekten en düþüðe sýrala:

SELECT * FROM PERSON
ORDER BY SALARY

--14. En yüksek maaþ alan 5 çalýþaný listele:

SELECT TOP 5* FROM PERSON
ORDER BY SALARY DESC
















