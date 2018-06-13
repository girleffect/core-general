*** Settings ***
Library  SeleniumLibrary
Library  OperatingSystem
Library  XvfbRobot

*** Variables ***

*** Keywords ***
Begin Web Test
    Start Virtual Display  1920  1080
    Open Browser  ${URL.${ENVIRONMENT}}  ${BROWSER}

End Web Test
    Close All Browsers

Set Window Size 800 By 600
    Set Window Size  800  600

Start Docker Container
    Run  ../tests/pytest.sh

Stop All Containers
    Run  docker stop $(docker ps -aq)