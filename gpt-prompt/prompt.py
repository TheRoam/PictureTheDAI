from transformers import pipeline, set_seed
import argparse
import random

parser=argparse.ArgumentParser()

parser.add_argument(
	"-p", type=str, nargs="?")

opt=parser.parse_args()
prompt=opt.p

seed=random.randint(100,1000000)
set_seed(seed)
print("Using seed: "+str(seed))

pipe = pipeline('text-generation', model='Gustavosta/MagicPrompt-Stable-Diffusion', tokenizer='gpt2')

def get_valid_prompt(text: str) -> str:
  dot_split = text.split('.')[0]
  n_split = text.split('\n')[0]

  print(dot_split)
  print(n_split)
 #return(dot_split)

  return {
    len(dot_split) < len(n_split): dot_split,
    len(dot_split) > len(n_split): n_split,
    len(n_split) == len(dot_split): dot_split
  }[True]

valid_prompt = get_valid_prompt(pipe(prompt, max_length=random.randint(60,200), num_return_sequences=1)[0]['generated_text'])
print(valid_prompt)

f = open("prompt", "w")
f.write(valid_prompt)
f.close()
