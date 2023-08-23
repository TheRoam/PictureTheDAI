#!/usr/bin/bash

source ~/Documents/stable-diffusion/sdAI/bin/activate

bash ~/Documents/torch/install_torch.sh

pip3 uninstall diffusers
pip3 install diffusers

deactivate

