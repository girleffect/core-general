#!/bin/bash

stop_signal_received() {
    exit
}

trap stop_signal_received SIGINT

while true; do
    robot -d robot/results/ -i ready -v BROWSER:chrome -v ENVIRONMENT:qa robot/tests/Springster-Demo-Site.robot
    sleep 3600
done
