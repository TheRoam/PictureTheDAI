#!/usr/bin/bash

#Activate python environment
dirg="~/Documents/gpt-prompt"
source $dirg/gptP/bin/activate

# Clear previous prompt

echo "?">$dirg/prompt

# Read prompt file
f=$(cat $dirg/prompt)

# Get time of the day
H=$(date +%H)

if [[ $H = '00' ]] || [[ $H = '0' ]]

then

	L=$(wc -l $dirg/p24.txt | cut -d " " -f 1)
	r=$(echo $(( $RANDOM % $L )) )
	p=$(sed -n $r'p' $dirg/p24.txt)
	echo "🌜 Sweet dreams!">$dirg/msg


elif [[ $H = '03' ]] || [[ $H = '3' ]]
then

	L=$(wc -l $dirg/p3.txt | cut -d " " -f 1)
	r=$(echo $(( $RANDOM % $L )) )
	p=$(sed -n $r'p' $dirg/p3.txt)
	echo "💤 Shhh...!">$dirg/msg

elif [[ $H = '06' ]] || [[ $H = '6' ]]
then

	L=$(wc -l $dirg/p6.txt | cut -d " " -f 1)
	r=$(echo $(( $RANDOM % $L )) )
	p=$(sed -n $r'p' $dirg/p6.txt)
	echo "🌇 Morning!">$dirg/msg

elif [[ $H = '09' ]] || [[ $H = '9' ]]
then

	L=$(wc -l $dirg/p9.txt | cut -d " " -f 1)
	r=$(echo $(( $RANDOM % $L )) )
	p=$(sed -n $r'p' $dirg/p9.txt)
	echo "☕ Coffee break?">$dirg/msg

elif [[ $H = '12' ]]
then

	L=$(wc -l $dirg/p12.txt | cut -d " " -f 1)
	r=$(echo $(( $RANDOM % $L )) )
	p=$(sed -n $r'p' $dirg/p12.txt)
	echo "🏔 Breathe...">$dirg/msg

elif [[ $H = '15' ]]
then

	L=$(wc -l $dirg/p15.txt | cut -d " " -f 1)
	r=$(echo $(( $RANDOM % $L )) )
	p=$(sed -n $r'p' $dirg/p15.txt)
	echo "🍝 Bon appétit!">$dirg/msg

elif [[ $H = '18' ]]
then

	L=$(wc -l $dirg/p18.txt | cut -d " " -f 1)
	r=$(echo $(( $RANDOM % $L )) )
	p=$(sed -n $r'p' $dirg/p18.txt)
	echo "🙌 Free time!">$dirg/msg

elif [[ $H = '21' ]]
then

	L=$(wc -l $dirg/p21.txt | cut -d " " -f 1)
	r=$(echo $(( $RANDOM % $L )) )
	p=$(sed -n $r'p' $dirg/p21.txt)
	echo "🌌 Nighty nights!">$dirg/msg

else
	# Print "-1" to file to recognise wrong time
	echo "No prompt for this moment of the day!"
	echo "-1" > $dirg/prompt
	echo "!">$dirg/msg
	deactivate
	exit

fi

echo "Using prompt start: "$p

python3 $dirg/prompt.py -p "$p"

f=$(cat $dirg/prompt)

if [[ $f = "?" ]]
then
	echo "ERROR!! No prompt"

	echo "Reinstalling transformers"
	bash $dirg/reinstall.sh

	#reactivate environment deactivated during reinstall
	source $dirg/gptP/bin/activate
	echo "Retrying using prompt start: "$p

	python3 $dirg/prompt.py -p "$p"

	sleep 2
	f=$(cat $dirg/prompt)

	if [[ $f = "?" ]]
	then
		echo "ERROR!! No prompt again"

		echo "Reinstalling transformers"
		bash $dirg/reinstall.sh
		
		#reactivate environment
		source $dirg/gptP/bin/activate

		echo "Retrying using prompt start: "$p

		python3 $dirg/prompt.py -p "$p"

		sleep 2
		f=$(cat $dirg/prompt)

		if [[ $f = "?" ]]
		then
			echo "ERROR!! Definetly no prompt. Check what's wrong!"
			deactivate
			exit
		fi
	fi
fi


echo "Whole prompt:"
cat $dirg/prompt | wc -c

echo "Trimmed prompt:"
t=$(cat $dirg/prompt)
echo ${t:0:250}>$dirg/prompt
cat $dirg/prompt | wc -c


deactivate

