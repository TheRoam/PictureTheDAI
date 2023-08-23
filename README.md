# #PictureTheDAI🖼

## Description
#PictureTheDAI is a Stable Diffusion image generation twitter bot that creates special images for every moment of the day.

Follow my twitter bot [@ThRoWtrw](https://twitter.com/ThRoWtrw/status/1670879416904216595) to see the results:

![Merge1](https://github.com/TheRoam/PictureTheDAI/assets/63456390/3d3ddc73-3ba0-4f17-9a83-1b17f808db98)
![Merge2](https://github.com/TheRoam/PictureTheDAI/assets/63456390/a52e338e-0940-4818-a66c-5a1c428beb0c)

ℹ️ **I'm not a professional programmer, so any errors, feedback or improvements, let me know by opening an issue** 🧏‍♂️

## Features
  - Random prompt generation using gpt2-based **Magic Prompt** by Gustavosta
  - **Stable Diffusion v1.5** optimized generation for < 8GB RAM
  - **Real-ESRGAN** upscaling by xinntao
  - Twitter API upload and post using **tweepy**.

## Requirements
Those of Stable Diffussion v1.5:
  - Python3
  - Nvidia graphics card with CUDA drivers and > 4 GB RAM
  - Recommended Linux OS for compatibility with bash scripts

Mine runs in an **Nvidia Jetson Xavier** which is nothing but friendly, so apologies in advance for the workarounds.

## Bugs & glitches
- Torch with CUDA is very faulty in the Xavier, so every module requires its own python enviroment for easy fix.
- When torch gets broken, it gets solved by reinstalling it. Hence, the individual environments.
- When a python script ends, it doesn't clear the used RAM, so the cache needs clearing via
```
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches***
```

## Cycle workflow
Cycles take place every ~3 hours: at 3, 6, 12, 15, 18, 21 and 24 (UTC+2)

Every cycle runs as follows:

**1. sd-randtweet/Loop.sh**
  - Calls the Stable Diffusion generation
  - Checks wether an image was created
  - Then calls the twitter upload script
  - Finally, goes to sleep until next loop.

**2. sd-randtweet/randSD.sh**
_Handles the image generation_
  - Calls the prompt generator
  - Reinstalls torch if it fails, and retries
  - Calls the image generator with the prompt
  - Reinstalls torch if it fails, and retries
  - Calls the upscaler with the generated image

**3. gpt-prompt/randP.sh**
  _Handles the prompt generator_
  - Reads the current hour of the day
  - Defines a message for twitter according to the time of the day
  - Chooses a random prompt start from the list according to the time of the day
  - Using Magic Prompt, generates a Stable Diffusion prompt from the random prompt start
  - Reinstalls dependencies if it fails, and retries

**4. gpt-prompt/prompt.py**
  _Runs Magic Prompt_
  - Uses the prompt start and a random seed to generate a Stable Diffusion prompt.

**5. stable-diffusion/diff.py**
  _Runs Stable Diffusion_
  - Uses the generated prompt to run Stable Diffusion v1.5 with low resources
  - Model: Realistic Vision v5
  - Optimizations: fp16 model variant + sequential cpu offload

**6. sd-randtweet/upscale.sh**
_Handles image upscaling_
  - Calls the proper environment
  - Calls the upcale script.
  - Returns upscaled image to **results** folder

**7. sd-randtweet/tweet.py**
_Runs the twitter API using tweepy_
  - Authorizes account
  - Uploads image to Twitter
  - Grabs media code
  - Defines Tweet message
  - Attaches media with prompt in ALT
  - Replies to #PictureTheDAI thread
