#!/usr/bin/bash

#Clear cache to free RAM
echo "--Clearing cache"
#bash clear_cache.sh
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***

dir="/home/enano/Documents/sd-randtweet"
dirSD="/home/enano/Documents/stable-diffusion/ComfyUI/output"

#Remove existing image
rm $dir/image.png $dir/results/image_out.png

#Move to prompt generator
dirg="/home/enano/Documents/gpt-prompt"
cd $dirg

echo "0">$dirg/prompt

echo "--Generating a random prompt"

bash $dirg/randP.sh

p=$(cat $dirg/prompt)

# Check if wrong time
if [[ $p = '-1' ]]
then
	echo "WRONG TIME!! No generation needed. Quiting!"
	exit
fi

if [[ $p = "0" ]]
then
	echo "ERROR!! No prompt created"
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
#bash clear_cache.sh
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***

#Call COmfyUI with prompt
echo "--Sending prompt to ComfyUI"

#Prepare config.
#Get first three lines
config="/home/enano/Documents/stable-diffusion/Comfy.json"
head -n 3 /home/enano/Documents/stable-diffusion/Comfy-template.json > $config

#Wrtie a random seed value
echo '      "seed": '$(($RANDOM*$RANDOM/$RANDOM))',' >> $config

#Get intermmediate variables
head -53 /home/enano/Documents/stable-diffusion/Comfy-template.json | tail +5 >> $config

#Write prompt
echo '      "text": "'$p'",' >> $config

#Write remaining file
tail -54 /home/enano/Documents/stable-diffusion/Comfy-template.json >> $config

#Send config to ComfyUI
echo "--Launching ComfyUI generation"
curl -X POST --data @$config http://192.168.1.92:8188/prompt

#waiting for image
while [ $(ls -l /home/enano/Documents/stable-diffusion/ComfyUI/output/ | wc -l) == "1" ]
do
	echo "---Waiting for image"
	sleep 5
done

mv /home/enano/Documents/stable-diffusion/ComfyUI/output/* image.png

img=$(ls | grep "image.png")

if [[ $img = "image.png" ]]
then
	echo "Success! Image exists"
fi
#deactivate

#clear cache after operation
echo "--Clearing cache"
#bash clear_cache.sh
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***

#Upscale image
#rm ./results/image_out.png
echo "--Upscaling image"

bash upscale.sh

img=$(ls ./results | grep "image_out.png")

if [[ $img = "image_out.png" ]]
then
        echo "Success! Image exists"
else
        echo "ERROR!! No image created"
        echo "Clearing cache"
        #bash clear_cache.sh
	sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***
        #echo "Reinstalling torch"
	#rm -rf ~/.local/lib/python*
        #bash /home/enano/Documents/torch/install_torch.sh
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
#bash clear_cache.sh
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***

#Update job number
j=$(cat job)
echo "Updating job No."$j
echo $(($j+1)) > job
j=$(cat job)
echo "now No."$j

#Save image with job number
echo "Saving image in /results/image_"$j".png"
cp $dir/results/image_out.png $dir/results/image_$j.png

echo "--Process completed successfully!"
