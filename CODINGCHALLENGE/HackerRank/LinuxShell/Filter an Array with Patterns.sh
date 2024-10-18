i=0
while read line
do
    a[$i]=$line
    export value=`echo ${a[$i]} | grep -v a | grep -v A | wc -l`
    if (( $value == 1)) then
        echo ${a[$i]}      
        fi
     i=$((i + 1)) 
done