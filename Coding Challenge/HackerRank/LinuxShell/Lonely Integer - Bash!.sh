read num
read -a arr 

for i in ${arr[@]}
do 
count=0
    for j in ${arr[@]}
    do
        if (( $i == $j ))
        then 
        count=`expr $count+1`
        fi
    done        
    if (( $count == 1 )) then
    echo $i
    fi
done
