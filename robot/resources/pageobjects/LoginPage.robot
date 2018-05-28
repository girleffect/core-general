*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${loginpage.auth_username}  name:auth-username
${loginpage.auth_password}  name:auth-password

*** Keywords ***

Enter Auth Username
    [Arguments]  ${UserData}

    Input Text  name:auth-username  ${UserData.username}

Enter Auth Password
    [Arguments]  ${UserData}

    Input Text  name:auth-password  ${UserData.pwd}

Submit
    Click Button  Login

Verify Login
    Wait Until Page Contains  Login

Confirm Account Blocked
    Wait Until Page Contains  Your account has been deactivated. Please contact support.
