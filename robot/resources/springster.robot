*** Settings ***
Resource  ../resources/pageobjects/LandingPage.robot
Resource  ../resources/pageobjects/LoginPage.robot
Resource  ../resources/pageobjects/RegistrationPage.robot
Resource  ../resources/pageobjects/AuthPage.robot
Resource  ../resources/pageobjects/ManagementPortal.robot
Resource  ../resources/pageobjects/ProfileHome.robot
Resource  ../resources/pageobjects/PasswordReset.robot

*** Variables ***

*** Keywords ***

Generate User Name
    ${RND_USER} =  Generate Random String  8  [LETTERS]
    Set Global Variable  ${RND_USER}

Assert Landing Page Header
    LandingPage.Verify Landing Page

Verify User Form Fields
    [Arguments]  ${type}

    LandingPage.Load Landing Page
    LandingPage.Open Registration Form  ${type}
    RegistrationPage.Verify User Fields  ${type}

Authorise Registration
    AuthPage.Verify Auth Page
    AuthPage.Authorise

Decline Registration
    AuthPage.Decline

Login As User
    [Arguments]  ${UserData}

    LandingPage.Load Landing Page
    LandingPage.Login
    LoginPage.Enter Auth Username  ${UserData}
    LoginPage.Enter Auth Password  ${UserData}
    LoginPage.Submit

Logout
    ProfileHome.Logout

Login To CMS
    [Arguments]  ${AUTH_USERNAME}  ${AUTH_PASSWORD}
    
    LandingPage.Load CMS
    LandingPage.Verify Admin Login Page
    LoginPage.Enter Auth Username  ${AUTH_USERNAME}
    LoginPage.Enter Auth Password  ${AUTH_PASSWORD}
    LoginPage.Click Submit

Registration Questions
    [Arguments]  ${type}
    
    LandingPage.Load Landing Page
    LandingPage.Open Registration Form  ${type}
    RegistrationPage.Question Usage

Password Length Error
    Set Selenium Implicit Wait  5s
    RegistrationPage.Password Length Error

Password Format Error
    Wait Until Page Contains  

#Enable 2FA
#    RegistrationPage.Verify System User Login

#Grab Code
#    ${qr} = Get Value  xpath://*[@class="QR-image"]
Open Management Portal
    ManagementPortal.Load GMP

Search For User
    [Arguments]  ${user}
    
    ManagementPortal.Find User  ${user}

Set User To Inactive
    ManagementPortal.Toggle User Activation
    ManagementPortal.Save
    #ManagementPortal.Confirm Change

Ensure Login Blocked
    LoginPage.Confirm Account Blocked

Ensure Login Successful
    AuthPage.Verify Auth Page

Exceed Login Attempts
    LoginPage.Login As User Incorrect Password

Assert User Logged In
    ProfileHome.Verify User Home Page

Create New Profile
    [Arguments]  ${UserData}

    LandingPage.Load Landing Page
    LandingPage.Open Registration Form  ${UserData}
    RegistrationPage.Set No-validate
    RegistrationPage.Verify Registration Form
    RegistrationPage.Enter User Details  ${UserData}
    RegistrationPage.Submit Form

Delete User Profile
    [Arguments]  ${UserData}

    girleffect_api.Delete User  ${UserData}

Assert Registration Errors
    RegistrationPage.Assert Field Errors

Check Password Reset Email
    PasswordReset.Check Reset Email

Reset Password Via Email
    [Arguments]  ${UserData}

    LandingPage.Load Landing Page
    LandingPage.Login
    LoginPage.Reset Password Link
    PasswordReset.Verify Reset Page Header
    PasswordReset.Fill In Email  ${UserData}
    PasswordReset.Click Submit
    PasswordReset.Verify Reset Sent

Reset Password Via Questions
    [Arguments]  ${UserData}

    LandingPage.Load Landing Page
    LandingPage.Login
    LoginPage.Reset Password Link
    PasswordReset.Verify Reset Page Header
    PasswordReset.Fill In Username  ${UserData}
    PasswordReset.Click Submit
    PasswordReset.Verify Reset Sent