## Description
This folders holds the environment for random prompt generation using Magic Prompt

- **randP.sh** handles time and chosen prompt start

- **pX.txt** files contain prompt starts according to X hour of the day

- **prompt.py** runs Magic Prompt

## Installation
- Install rust compiler

_(needed for safetensors in JetPack 5.0.2, you may not need it)_
```
sudo apt-get install rustc cargo
```
- Create python environment

```
python3 -m venv gptP

source gptP/bin/activate

pip3 install pip --upgrade
```

- Install torch with CUDA, whichever way fits your machine
- For Jetson Xavier NX JetPack 5.0.2 we can use **reinstall.sh** script:

```
bash ~/Documents/torch/reinstall.sh
```
