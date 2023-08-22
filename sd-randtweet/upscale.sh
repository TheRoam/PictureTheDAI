#!/bin/usr/bash

dir="/home/enano/Documents/sd-randtweet"
dirU="/home/enano/Documents/Real-ESRGAN"

source $dirU/reGAN/bin/activate

python3 $dirU/inference_realesrgan.py --model_name realesr-general-x4v3 -i $dir/image.png -o $dir/results
