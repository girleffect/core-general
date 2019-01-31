#!/usr/bin/env python

# pip install boto3
# pip install requests
# pip install requests-aws4auth

# Usage:
#
# python query_elasticsearch.py qa 'RESOURCE_CRUD' | python -m json.tool | less
#
# Make sure your ElasticSearch credentials are stored in `~/.aws/config` in a
# profile called "es-cli" (or modify this script) to support it as an arg.
#

from requests_aws4auth import AWS4Auth
from urllib import urlencode
import boto3
import requests
import sys

env_to_host_map = {
    "qa": 'https://search-ge-event-log-qeyhk65xsespxycxrxbw3ievfq.eu-west-1.es.amazonaws.com',
    "prod": 'https://search-ge-event-log-goljhod5hxs72upk3oba2hwq2y.eu-west-1.es.amazonaws.com'
}
path = '/'
region = 'eu-west-1'

service = 'es'

env_to_profile_name_map = {
    "prod": "prod-es-cli",
    "qa": "qa-es-cli"
}

environment = sys.argv[1]
credentials = boto3.Session(profile_name=env_to_profile_name_map[environment]).get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service)

params = {
    "q": sys.argv[2],
    "sort": "timestamp:desc"
}
url = env_to_host_map[environment] + path + "_search?" + urlencode(params)

r = requests.get(url, auth=awsauth)

print(r.text)
