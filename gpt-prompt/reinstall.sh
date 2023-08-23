#!/usr/bin/bash

source /home/enano/Documents/gpt-prompt/gptP/bin/activate
pip3 uninstall transformers torch
pip3 install transformers torch

deactivate
