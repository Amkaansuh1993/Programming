i=0
while read line || [[ -n "$line" ]]
    do
        arr[$i]=$line
        i=$((i + 1))
    done
    
echo ${#arr[@]}