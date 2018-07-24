#!/bin/bash

export OLD=$1
export NEW=$2
function md5check(){
	local old=$1
	local new=$2
	for file in `ls $old`; do
		if [ -f "$old/$file" ]; then
			local old_md5=$(md5 -q $old/$file)
			local new_md5=$(md5 -q $new/$file)


			if [ "$old_md5" != "$new_md5" ]; then
				echo $new/$file
			fi
		elif [ -d "$old/$file" ]; then
			md5check $old/$file $new/$file
		fi


	done
}

md5check $OLD $NEW