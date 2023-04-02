import json
import requests
import sys

retrieveMeta = sys.argv[1] if len(sys.argv)>1 else None
metaURL = "http://169.254.169.254/latest/meta-data"
metadata = {}
resp = requests.get(url=metaURL)
for data in resp.text.splitlines():
    if not data.endswith('/'):
        value = requests.get(url= f'{metaURL}/{data}').text
        metadata[data] = value if value else 'None'

if retrieveMeta: print(metadata[retrieveMeta])
else: print(json.dumps(metadata,indent=4))
