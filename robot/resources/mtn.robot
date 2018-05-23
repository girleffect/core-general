*** Settings ***

*** Variables ***

*** Keywords ***
Hover Over Buy
    Mouse Over  xpath://*[contains(text(), "Buy")]
    Element Should Be Visible  xpath://*[@class="Navigation-menu Navigation-menu--tier2"]

Go To Devices
    Click Element  xpath://*[@class="Navigation-menu Navigation-menu--tier2"]
    Click Link  xpath://*[contains(text(), "Phones & Devices")]

Check Responsive Header
    Set Window Size 800 By 600
    Element Should Be Visible  

