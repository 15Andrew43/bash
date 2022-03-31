#!/bin/bash


get_q () {
	ch="~"
	str=$1
	for ((i=0; i < ${#str}; i++))
	do
		cur=${str:$i:1}
		if [ "$cur" \< "$ch" ]
		then
			ch=$cur
		fi
	done
	
	echo $ch
}


while [ $# -gt 0 ]
do
	key=$1
	case $key in
		--name)
			name=$2
			shift 2
			;;
		-n|--number)
			number=$2
			shift 2
			;;
		-t|--trash_holder)
			trash_holder=$2
			shift 2
			;;
		-o|--out_file)
			out_file=$2
			shift 2
			;;
		*)
			shift 1
			;;
	esac
done




rm $out_file


cnt=0
zcat $name |
while read line0
do
	if [[ $number != "" ]] && [ $number -le $cnt ]
	then
		break
	fi
	read agct
	read line2
	read quality
	min_q=""
	if [[ $trash_holder != "" ]]
	then
		min_q=$(get_q $quality)
	fi

	if [[ $trash_holder == "" ]] || [ "$min_q" \> "$trash_holder" ]
	then 
		echo $line0 >> $out_file
		echo $agct >> $out_file
		echo $line2 >> $out_file
		echo $quality >> $out_file
		cnt=$(($cnt + 1))
	fi
	
done


tar -czvf "$out_file.tzr.gz" $out_file

rm $out_file


