#!/bin/bash


while [ $# -gt 0 ]
do
	key=$1
	case $key in
		-n|--num_workers)
			num_workers=$2
			shift 2
			;;
		-i|--input_file)
			input_file=$2
			shift 2
			;;
		-l|--links_index)
			links_index=$2
			shift 2
			;;
		-o|--output_folder)
			output_folder=$2
			shift 2
			;;
		*)
			shift 1
			;;
	esac
done



mkdir $output_folder


awk -v links_index=$links_index -F";" '{print $links_index}' $input_file | parallel -j $num_workers wget -P $output_folder -p
