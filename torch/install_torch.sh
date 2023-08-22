#!/usr/bin/bash

export TORCH_INSTALL=~/Documents/torch

python3 -m pip install --upgrade pip

python3 -m pip install aiohttp numpy==1.19.4 scipy==1.5.3

export LD_LIBRARY_PATH="/usr/lib/llvm-8/lib:$LD_LIBRARY_PATH"

python3 -m pip install --upgrade protobuf

python3 -m pip install --no-cache $TORCH_INSTALL
