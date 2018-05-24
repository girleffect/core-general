*** Settings ***
Library  SeleniumLibrary

*** Variables ***

${landingpage.login} =  //a[@href="/oidc/authenticate/"]
${landingpage.admin_login} =  //a[@href="/protected/"]
${landingpage.register_user_btn} =  id:endUserRedirectButton
${landingpage.register_admin_btn} =  id:systemUserRedirectButton

*** Keywords ***
Load Landing Page
    Go To  ${URL.${ENVIRONMENT}}

Load CMS
    #Click Link  ${LandingPage.admin_login}
    Go To  ${CMS_URL}

Open Registration Form
    [Arguments]  ${type}

    Run Keyword If  "${type}" == "end-user"  Click Link  ${landingpage.register_user_btn}
    ...  ELSE IF  "${type}" == "system-user"  Click Link  ${landingpage.register_admin_btn}
    ...  ELSE  Log  Invalid user specified.

Verify Landing Page
    Wait Until Page Contains  Basic demo: Click and go

Verify Admin Login Page
    Wait Until Page Contains  Login

Login
    Click Link  ${landingpage.login}

