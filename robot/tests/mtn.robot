*** Settings ***
Documentation  This is a set of tests for the Springster demo site.
Resource  ../resources/common.robot  # used for setup and teardown
Resource  ../resources/mtn.robot  # stores lower level keywords used by test.

#Suite Setup
Test Setup  Begin Web Test
Test Teardown  End Web Test
#Suite Teardown

*** Variables ***

${BROWSER} =  chrome
${START_URL} =  http://brightside.qa.praekelt.com/

*** Test Cases ***
Mouse over buy menu
    [Tags]  ready
    
    mtn.Hover Over Buy
    mtn.Go To Devices