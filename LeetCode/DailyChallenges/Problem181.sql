select AA.name as Employee from 
(select A.id,A.name,A.salary as ES ,B.salary as MS from Employee A left join Employee B on A.managerid = B.id) AA
where AA.ES > AA.MS