from torch import autocast, cuda, float16
import argparse
from diffusers import StableDiffusionPipeline
import gc

cuda.empty_cache()
gc.collect()

pipe = StableDiffusionPipeline.from_pretrained(
    "SG161222/Realistic_Vision_V5.0_noVAE",
    torch_dtype=float16,
)

parser=argparse.ArgumentParser()

parser.add_argument(
	"-p", type=str, nargs="?")


opt=parser.parse_args()
prompt=opt.p
n_prompt="nipple, nipples, breasts, xxx, erotic, violent, blood, ugly, tiling, poorly drawn hands, poorly drawn feet, poorly drawn face, out of frame, extra limbs, disfigured, deformed, body out of frame, bad anatomy, watermark, signature, cut off, low contrast, underexposed, overexposed, bad art, beginner, amateur, distorted face"

pipe.enable_sequential_cpu_offload()
image = pipe(prompt, negative_prompt=n_prompt, num_inference_steps=50).images[0]
image.save("image.png")

opt=None
image=None
parser=None
pipe=None

cuda.empty_cache()
gc.collect()
quit()
