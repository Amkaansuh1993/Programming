CREATE DELIMITER root@mydatabase FUNCTION `getNthHighestSalary`(N INT) RETURNS int(11)
BEGIN
SET N = N-1;
  RETURN (
      SELECT DISTINCT(salary) from Employee order by salary DESC
      LIMIT 1 OFFSET N  );
END

SELECT getNthHighestSalary(2);