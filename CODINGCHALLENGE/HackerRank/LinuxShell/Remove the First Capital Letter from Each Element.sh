i=0
while read line || [[ -n "$line" ]]
    do
        arr[$i]=`echo $line | sed 's/^././g'`
        i=$((i + 1))
    done

echo ${arr[@]}
