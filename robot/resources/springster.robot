*** Settings ***
Resource  ../resources/pageobjects/LandingPage.robot
Resource  ../resources/pageobjects/LoginPage.robot
Resource  ../resources/pageobjects/RegistrationPage.robot
Resource  ../resources/pageobjects/AuthPage.robot
Resource  ../resources/pageobjects/ManagementPortal.robot
Resource  ../resources/pageobjects/UserHome.robot

*** Variables ***

*** Keywords ***
Create User String
    RegistrationPage.Create Random User

Verify User Form Fields
    [Arguments]  ${type}

    LandingPage.Load Landing Page
    LandingPage.Open Registration Form  ${type}
    RegistrationPage.Verify User Fields  ${type}

Register As User
    [Arguments]  ${type}  ${RANDOM_USER}  ${RANDOM_PWD}

    LandingPage.Load Landing Page
    LandingPage.Open Registration Form  ${type}
    RegistrationPage.Verify Registration Form
    RegistrationPage.Enter User Fields  ${type}  ${RANDOM_USER}  ${RANDOM_PWD}
    RegistrationPage.Submit Form

Authorise Registration
    AuthPage.Verify Auth Page
    AuthPage.Authorise

Decline Registration
    AuthPage.Decline

Login As User
    [Arguments]  ${type}  ${RANDOM_USER}  ${RANDOM_PWD}

    LandingPage.Load Landing Page
    LandingPage.Login
    LoginPage.Enter Auth Username  ${RANDOM_USER}
    LoginPage.Enter Auth Password  ${RANDOM_PWD}
    LoginPage.Submit

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
    UserHome.Verify User Home Page