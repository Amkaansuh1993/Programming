 select max(salary) as SecondHighestSalary  from employee where salary < (SELECT max(salary) from employee)