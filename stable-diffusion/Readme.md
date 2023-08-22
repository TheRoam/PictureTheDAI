## Description
This folders holds the environment for stable diffusion image generation using the previously generated prompt.

- **diff.py** runs Stable Diffusion with low-ram optimizations

## Installation
- Create python environment

```
python3 -m venv sdAI

source sdAI/bin/activate
```

- Install torch with CUDA, whichever way fits your machine
- For Jetson Xavier NX JetPack 5.0.2 see the script in the **torch** folder:

```
bash ~/Documents/torch/install_torch.sh
```

- Install dependencies

```
pip3 install -r requirements.txt
```
