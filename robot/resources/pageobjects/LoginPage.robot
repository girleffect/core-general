*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${loginpage.auth_username}  name:auth-username
${loginpage.auth_password}  name:auth-password
${loginpage.lost_pwd_link}  xpath://a[@href="/en/reset-password/"]
${loginpage.content}  xpath://div[@id="content"]/p[1]

*** Keywords ***
Assert Site Status
    [Arguments]  ${site_active}
    
    Run Keyword If  "${site_active}" == "false"  Wait Until Page Contains  Site access disabled
    ...  ELSE IF  "${site_active}" == "true"  Wait Until Page Contains  Login

Fill In Form
    [Arguments]  ${UserData}

    Input Text  name:auth-username  ${UserData.username}
    Input Text  name:auth-password  ${UserData.pwd}
    Click Button  Login
    
Enter Auth Username
    [Arguments]  ${UserData}

    Input Text  name:auth-username  ${UserData.username}

Enter Auth Password
    [Arguments]  ${UserData}

    Input Text  name:auth-password  ${UserData.pwd}

Enter Custom Username
    [Documentation]  Use this keyword if you don't want to be tied to the details in ${UserData}.
    [Arguments]  ${username}

    Input Text  name:auth-username  ${username}

Enter Custom Password
    [Documentation]  Use this keyword if you don't want to be tied to the details in ${UserData}.
    [Arguments]  ${password}

    Input Text  name:auth-password  ${password}
    
Submit
    Click Button  Login

Verify Login
    Wait Until Page Contains  Login

    Element Should Be Visible  ${loginpage.auth_username}
    Element Should Be Visible  ${loginpage.auth_password}

Confirm Account Blocked
    Wait Until Page Contains  Your account has been deactivated. Please contact support.

Reset Password Link
    #Click Element  ${loginpage.lost_pwd_link}
    Click Link  Click here to reset it.

Assert Max Login Error
    Wait Until Page Contains  Oh no! You've been locked out
    Element Text Should Be  ${loginpage.content}  You have exceeded the maximum number of allowed incorrect login attempts (5). Please wait 10 minutes before trying again.
    #Element Should Be Visible  xpath://a[@href="/en/login/"]

Verify Login Error
    [Arguments]  ${UserData}

    Wait Until Page Contains  ${UserData.error}