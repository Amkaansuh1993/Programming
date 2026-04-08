Select earnings, countEmp 
from (Select max(E.earnings) as earnings,count(E.employee_id) as countEmp 
from (Select employee_id,salary,months*salary as earnings from Employee) E group by E.earnings order by E.earnings desc) e  LIMIT 1;