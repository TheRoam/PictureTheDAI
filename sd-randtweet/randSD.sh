#!/usr/bin/bash

#Clear cache to free RAM
echo "--Clearing cache"
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***

dir="~/Documents/sd-randtweet"
dirSD="~/Documents/stable-diffusion"

#Remove existing image
rm $dir/image.png $dir/results/image_out.png

#Move to prompt generator
dirg="~/Documents/gpt-prompt"
cd $dirg

echo "0">$dirg/prompt

echo "--Generating a random prompt"

#Run propmpt generator
bash $dirg/randP.sh

#Get generated prompt
p=$(cat $dirg/prompt)

# Check if wrong time
if [[ $p = '-1' ]]
then
	echo "WRONG TIME!! No generation needed. Quiting!"
	exit
fi

#Check if prompt exists
if [[ $p = "0" ]]
then
	echo "ERROR!! No prompt created"
	#Reinstall torch and try again
	echo "Reinstalling torch in gptP"
	bash $dirg/reinstall.sh
	echo "Retrying prompt generation"
	bash $dirg/randP.sh

	p=$(cat $dirg/prompt)
	if [[ $p = "0" ]]
	then
		echo "ERROR!! No prompt created"
		echo "EXITING!! Check what's wrong"
		sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***
		exit
	fi
fi

#move back to folder
cd $dir

#Clear cache to free RAM
echo "--Clearing cache"
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***

# Launch Stable Diffusion
echo "--Launching Stable Diffusion"

source $dirSD/sdAI/bin/activate
python3 $dirSD/diff.py -p "$p"

img=$(ls | grep "image.png")

if [[ $img = "image.png" ]]
then
	echo "Success! Image exists"
else
	echo "ERROR!! No image created"
	echo "Clearing cache"
	sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***

	echo "Reinstalling torch"
	bash ~/Documents/torch/install_torch.sh

	echo "Retrying image generation"
	python3 $dirSD/diff.py -p "$p"

	img=$(ls | grep "image.png")
	if [[ $img = "image.png" ]]
	then
		echo "Success! Image exists"
	else
		echo "ERROR!! No image created"
		echo "Cancelling operation. Revise whats wrong!"
		deactivate
		exit
	fi
fi
deactivate
#clear cache after operation
echo "--Clearing cache"
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***

#Upscale image
echo "--Upscaling image"

bash upscale.sh

img=$(ls ./results | grep "image_out.png")

if [[ $img = "image_out.png" ]]
then
        echo "Success! Image exists"
else
        echo "ERROR!! No image created"
        echo "Clearing cache"
    	sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***
        echo "Retrying upscaling"
        bash upscale.sh


        img=$(ls | grep "image_out.png")
        if [[ $img = "image_out.png" ]]
        then
                echo "Success! Image exists"
        else
                echo "ERROR!! No image created"
                echo "Cancelling operation. Revise whats wrong!"
		sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***
                exit
        fi
fi

echo "--Clearing final cache"
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***

echo "--Process completed successfully!"

j=$(cat job)
echo "Updating job No."$j
echo $(($j+1)) > job
j=$(cat job)
echo "now No."$j
