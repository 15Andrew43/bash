#!/bin/bash


round() {
	echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
}



while [ $# -gt 0 ]
do
	key=$1
	case $key in
		-i|--input)
			input=$2
			shift 2
			;;
		-r|--train_ratio)
			train_ratio=$2
			shift 2
			;;
		-tf|--train_file)
			train_file=$2
			shift 2
			;;
		-vf|--val_file)
			val_file=$2
			shift 2
			;;
		-s|--shuffle)
			shuffle=1
			shift 1
			;;
		*)
			shift 1
			;;
	esac
done


array=()
n_strs=0
while read line
do
    array[$n_strs]="$line"
    n_strs=$(($n_strs+1))
done < $input

n_train=$(round "$n_strs*$train_ratio" 0)



inds_array=($(shuf -i 0-$(($n_strs - 1)) -n $n_strs ))



rm $train_file 
rm $val_file



cnt=0
for ind in ${inds_array[@]}
do
	if (( $cnt < $n_train ))
	then
		echo ${array[$ind]} >> $train_file
	else
		echo ${array[$ind]} >> $val_file
	fi
	cnt=$(($cnt + 1))
done
