from requests_oauthlib import OAuth1Session
import os
import json
import argparse
import tweepy
import requests
import re

# In your terminal please set your environment variables by running the following lines of code.
# export 'CONSUMER_KEY'='<your_consumer_key>'
# export 'CONSUMER_SECRET'='<your_consumer_secret>'

consumer_key = os.environ.get("CONSUMER_KEY")
consumer_secret = os.environ.get("CONSUMER_SECRET")

parser=argparse.ArgumentParser()

parser.add_argument(
	"-txt", type=str, nargs="?")
parser.add_argument(
	"-job", type=str, nargs="?")
parser.add_argument(
	"-msg", type=str, nargs="?")


opt=parser.parse_args()
txt=opt.txt
job=opt.job
msg=opt.msg

altTxt="'"+txt+"'"+" using Magic-Prompt.\n\nDone in Stable Diffusion using Realistic Vision v5 checkpoint and upscaled with Real-ESRGAN"

print(altTxt)

# Authorization
oauth = OAuth1Session(
    "YOUR-API-KEY",
    "YOUR-API-KEY-SECRET",
    "YOUR-ACCESS-TOKEN",
    "YOUR-ACCESS-TOKEN-SECRET",
)

# Upload media using tweepy
tweepy_auth = tweepy.OAuth1UserHandler(
    "YOUR-API-KEY",
    "YOUR-API-KEY-SECRET",
    "YOUR-ACCESS-TOKEN",
    "YOUR-ACCESS-TOKEN-SECRET",
)

tweepy_api = tweepy.API(tweepy_auth)
post = tweepy_api.simple_upload("results/image_out.png")
text = str(post)
media_id=re.search("media_id=(.+?),",text).group(1)

# Create ALT text
tweepy_api.create_media_metadata(media_id, altTxt)

tweetTxt="#PictureTheDAI No."+job+"\n\n"+msg+"\n\n#PromptInALT\n\nAutomatically generated in a Jetson Xavier\n\n#AIArt #AIArtCommunity #StableDiffusion"

# Create request payload with all the data
payld={"text": tweetTxt, "reply": {"in_reply_to_tweet_id": "1670879416904216595"},"media": {"media_ids": ["{}".format(media_id)]}}
print(payld)



# Be sure to add replace the text of the with the text you wish to Tweet. You can also add parameters to post polls, quote Tweets, Tweet with reply settings, and Tweet to Super Followers in addition to other features.
payload = payld

# Making the request
response = oauth.post(
    "https://api.twitter.com/2/tweets",
    json=payload,
)

if response.status_code != 201:
    raise Exception(
        "Request returned an error: {} {}".format(response.status_code, response.text)
    )

print("Response code: {}".format(response.status_code))

# Saving the response as JSON
json_response = response.json()
print(json.dumps(json_response, indent=4, sort_keys=True))
