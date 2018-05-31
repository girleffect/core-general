*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${passwordreset.header}  id:header
${passwordreset.back_btn}  xpath://a[@href="http://${URL.${ENVIRONMENT}}/oidc/callback/"]
${passwordreset.input}  name:email
${passwordreset.input}  xpath://*//input[@value="Submit"]

*** Keywords ***

Fill In Email
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.input}  ${UserData.email}

Fill In Username
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.input}  ${UserData.username}

Click Submit
    Click Button  Submit

Back To Landing Page
    Click Element  ${passwordreset.back_btn}

Verify Reset Page Header
    Wait Until Page Contains Element  ${passwordreset.header}
    Element Text Should Be  ${passwordreset.header}  FORGOT YOUR PASSWORD?
