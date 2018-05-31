*** Settings ***
Library  SeleniumLibrary

*** Variables ***

${authpage.auth_btn} =  name:allow
${authpage.decline_btn} =  xpath://*[@class="Button Button--warning"]//*[@value="Decline"]

*** Keywords ***
Verify Auth Page
    Wait Until Page Contains  Request for Permission

Authorise
    Click Button  ${authpage.auth_btn}

Decline
    Click Button  ${authpage.decline_btn}
