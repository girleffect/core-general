#!/usr/bin/env sh
set -e

./scripts/createStream.sh &

/usr/bin/supervisord -n -c /etc/supervisord.conf
