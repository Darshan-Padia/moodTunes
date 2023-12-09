
from ytmusicapi import YTMusic
import requests

yt = YTMusic('backend/oauth.json')
rs = yt.get_mood_categories()

# yt.get_charts(country='ZZ')

req = 'https://saavn.me/modules?language=hindi,english'

resp = requests.get(req)
print(resp.json())


