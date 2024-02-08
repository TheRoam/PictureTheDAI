#!/usr/bin/bash

source ~/Documents/stable-diffusion/comfyAI/bin/activate

bash ~/Documents/torch/install_torch.sh

cd ~/Documents/torch/torchvision
export BUILD_VERSION=0.13.0
python3 ~/Documents/torch/torchvision/setup.py install

cd ~/Documents/stable-diffusion

pip3 install -r ~/Documents/stable-diffusion/ComfyUI/requirements.txt

deactivate
