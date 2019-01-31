#!/usr/bin/env python

# pip install boto3
# pip install requests
# pip install requests-aws4auth

# Usage:
#
# python query_elasticsearch.py 'RESOURCE_CRUD' | python -m json.tool | less
#
# Make sure your ElasticSearch credentials are stored in `~/.aws/config` in a
# profile called "es-cli" (or modify this script) to support it as an arg.
#

from requests_aws4auth import AWS4Auth
from urllib import urlencode
import boto3
import requests
import sys

host = 'https://search-ge-event-log-qeyhk65xsespxycxrxbw3ievfq.eu-west-1.es.amazonaws.com'
path = '/'
region = 'eu-west-1'

service = 'es'
credentials = boto3.Session(profile_name="es-cli").get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service)

params = {
    "q": sys.argv[1],
    "sort": "timestamp:desc"
}
url = host + path + "_search?" + urlencode(params)

r = requests.get(url, auth=awsauth)

print(r.text)
