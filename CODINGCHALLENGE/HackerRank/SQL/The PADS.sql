select concat( Name , concat(concat('(',substr(Occupation,1,1)),')') ) from OCCUPATIONS order by Name asc;
select concat('There are a total of ',concat(count(occupation),concat(' ',lower(concat(occupation,'s.'))))) from OCCUPATIONS group by occupation order by count(occupation),occupation asc;