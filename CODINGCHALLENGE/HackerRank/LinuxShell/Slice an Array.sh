i=0
while read line
do
        a[$i]=$line
        i=$(($i + 1))
done 
echo ${a[@]:3:5}