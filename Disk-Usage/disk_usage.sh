#!/bin/bash

disk_storage=4

get_size () {
	size=$(($1 / 4096))
	if [[ $(($size * 4096)) != $1 ]]
	then
		size=$(($size + 1))
	fi
	echo $(($size * 4))
}

dfs () {
	for file in $1/*
	do
		if [[ $file == *"*" ]]
		then
			continue
		fi
		if [ -d $file ]
		then
			disk_storage=$(($disk_storage + 4))
			dfs $file
		else
			byte_size="$(ls -l $file | awk '{print $5}')"
			size=$(get_size $byte_size)
#			echo "$file size = $size"
			disk_storage=$(($disk_storage + $size))
		fi
	done
}

dfs $1

echo $disk_storage
