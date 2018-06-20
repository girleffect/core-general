#!/bin/bash

stop_signal_received() {
    exit
}

trap stop_signal_received SIGINT

mkdir -p results

if [ "${ENVIRONMENT}" == "docker" ]; then
    cd results && python -m SimpleHTTPServer &
fi

while true; do
    when=$(date -Iminute -u)
    mkdir -p results/${when}
    robot -d results/${when} -i ready -v BROWSER:chrome -v ENVIRONMENT:${ENVIRONMENT} tests/Springster-Demo-Site.robot
    sleep 120
done
