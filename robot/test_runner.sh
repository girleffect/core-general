#!/bin/bash

stop_signal_received() {
    exit
}

trap stop_signal_received SIGINT

mkdir -p results

# Run the HTTP daemon in all environments
cd results && python -m SimpleHTTPServer &

while true; do
    when=$(date -Iminute -u)
    mkdir -p results/${when}
    robot -d results/${when} -i ready -v BROWSER:chrome -v ENVIRONMENT:${ENVIRONMENT} tests/Springster-Demo-Site.robot
    sleep 120
done
