#!/bin/bash



while [ $# -gt 0 ]
do
	key=$1
	case $key in
		-jp|--json_path)
			json_path=$2
			shift 2
			;;
		-c|--category)
			category=$2
			shift 2
			;;
		-l|--limit_length)
			limit_length=$2
			shift 2
			;;
		-n|--numbers_objs_per_category)
			n_pairs_numbers=$2
			shift 2
			for (( i = 0; i < $n_pairs_numbers; i++ ))
			do
				numbers_objs_per_category[$1]=$2
				shift 2
			done
			;;
		-m|--limits_mask_size_per_category)
			n_pairs_masks=$2
			shift 2
			for (( i = 0; i < $n_pairs_masks; i++ ))
			do
				limits_mask_size_per_category[$1]=$2
				shift 2
			done
			;;
		*)
			shift 1
			;;
	esac
done



if [ $category != "" ]
then
	echo "category : $category"
	cat $json_path | jq '.annotations[] | select(.category_id == '$category') | .image_id'
elif [ $limit_length != "" ]
then
	cat $json_path | jq '.images[] | select(.height > '$limit_length' and .width > '$limit_length') | .id'
elif [ $n_pairs_numbers != "" ]
then
	KEYS=("${!numbers_objs_per_category[@]}") 
	for (( i=0;  $i < ${#numbers_objs_per_category[@]}; i+=1))
	do
		ind=${KEYS[$i]}
		echo "category : $ind, first ${numbers_objs_per_category[$ind]} items"
		cat $json_path | jq '.annotations | map(select(.category_id == '$ind'))[:'${numbers_objs_per_category[$ind]}']'
	done
fi