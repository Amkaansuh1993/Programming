select case 
when A + B <= C OR A + C <= B OR B + C <= A then 'Not A Triangle'
when A = B and B = C then 'Equilateral'
when A = B and B != C then 'Isosceles'
when A = C and B != C then 'Isosceles'
when B = C and A != B then 'Isosceles'
when B = C and A != C then 'Isosceles'
when A != B and B != C and C != A then 'Scalene' end as Triangle
from TRIANGLES;