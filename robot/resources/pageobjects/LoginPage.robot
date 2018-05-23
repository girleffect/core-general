*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${loginpage.auth_username}  name:auth-username
${loginpage.auth_password}  name:auth-password

*** Keywords ***

Enter Auth Username
    [Arguments]  ${AUTH_USERNAME}

    Input Text  name:auth-username  ${AUTH_USERNAME}

Enter Auth Password
    [Arguments]  ${AUTH_PASSWORD}

    Input Text  name:auth-password  ${AUTH_PASSWORD}

Submit
    Click Button  Login

Verify Login
    Wait Until Page Contains  Login

Confirm Account Blocked
    Wait Until Page Contains  Your account has been deactivated. Please contact support.
