select A.email as Email from 
(select count(email) as coun ,email from Person group by email ) A where coun != 1