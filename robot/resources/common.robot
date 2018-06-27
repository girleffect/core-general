*** Settings ***
Library  SeleniumLibrary
Library  OperatingSystem
#Library  XvfbRobot

*** Variables ***

*** Keywords ***
Begin Web Test
    #Start Virtual Display  1920  1080
    #${chrome_options} =     Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    #Call Method    ${chrome_options}   add_argument    headless
    #Call Method    ${chrome_options}   add_argument    disable-gpu
    #Call Method    ${chrome_options}   add_argument    no-sandbox
    #${options}=     Call Method     ${chrome_options}    to_capabilities
    
    Open Browser  ${URL.${ENVIRONMENT}}  ${BROWSER}  #desired_capabilities=${options}

End Web Test
    Close All Browsers

Set Window Size 800 By 600
    Set Window Size  800  600

Start Docker Container
    Run  ../tests/pytest.sh

Stop All Containers
    Run  docker stop $(docker ps -aq)
