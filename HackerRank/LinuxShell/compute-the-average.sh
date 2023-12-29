#!/bin/bash
read n;
i=1;
sum=0;
while [ $i -le $n ] 
do 
{ 
    read a; 
    sum=`expr $sum + $a`;
    i=`expr $i + 1`;
}
done;
printf "%0.3f"  $( echo `expr $sum/$n` | bc -l)