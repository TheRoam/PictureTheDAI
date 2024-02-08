#!/usr/bin/bash

dir="~/Documents/sd-randtweet"

l=0

while true
do
	l=$(($l+1))
	echo "----LOOP "$l"----"
	bash $dir/randSD.sh > $dir/SD.log

	img=$(ls $dir/results | grep "image_out.png")

	if [ $img == "image_out.png" ]
	then
		j=$(cat $dir/job)
		echo "--Uploading to Twitter"
		p=$(cat ~/Documents/gpt-prompt/prompt)
		msg=$(cat ~/Documents/gpt-prompt/msg)
		python3 $dir/tweet.py -txt "$p" -job $j -msg "$msg" > $dir/TW.log
	else
		echo "--ERROR!! Process failed. Check what happened"
	fi
	sleep 2700
done
