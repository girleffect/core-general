*** Settings ***
Resource  ../resources/pageobjects/LandingPage.robot
Resource  ../resources/pageobjects/LoginPage.robot
Resource  ../resources/pageobjects/RegistrationPage.robot
Resource  ../resources/pageobjects/AuthPage.robot
Resource  ../resources/pageobjects/ManagementPortal.robot
Resource  ../resources/pageobjects/ProfileHome.robot
Resource  ../resources/pageobjects/ProfileEdit.robot
Resource  ../resources/pageobjects/PasswordReset.robot
Resource  ../resources/pageobjects/UpdatePassword.robot
Resource  ../resources/pageobjects/UpdateQuestions.robot

*** Variables ***

*** Keywords ***

Generate User Name
    ${RND_USER} =  Generate Random String  8  [LETTERS]
    Set Global Variable  ${RND_USER}

Assert Landing Page Header
    LandingPage.Verify Landing Page

Create New Profile
    [Arguments]  ${UserData}

    LandingPage.Load Landing Page
    LandingPage.Open Registration Form  ${UserData}
    RegistrationPage.Set No-validate
    RegistrationPage.Verify Registration Form
    RegistrationPage.Enter User Details  ${UserData}
    RegistrationPage.Submit Form

Submit First End User Form
    [Arguments]  ${UserData}

    LandingPage.Load Landing Page
    LandingPage.Open Registration Form  ${UserData}
    RegistrationPage.Set No-validate
    RegistrationPage.Verify Registration Form
    RegistrationPage.First Registration Form Steps  ${UserData}

Check Registration Passed
    RegistrationPage.Verify Registration Successful

Verify User Form Fields
    [Arguments]  ${UserData}

    LandingPage.Load Landing Page
    LandingPage.Open Registration Form  ${END_USER_VALID}
    RegistrationPage.Verify User Fields  ${END_USER_VALID}

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

Registration Question Selection Validation
    [Arguments]  ${UserData}

    LandingPage.Load Landing Page
    LandingPage.Open Registration Form  ${UserData}
    RegistrationPage.Enter Username Field  ${UserData}
    RegistrationPage.Choose Gender From List  ${UserData}
    RegistrationPage.Enter Age Field  ${UserData}
    RegistrationPage.Enter Password Fields  ${UserData}
    RegistrationPage.Accept Terms
    RegistrationPage.Submit Form

    RegistrationPage.Select Specific Question  ${registration.form_question1}  ${UserData.first_question}
    RegistrationPage.Enter Answer One  ${UserData}
    RegistrationPage.Select Specific Question  ${registration.form_question2}  ${UserData.first_question}
    RegistrationPage.Enter Answer Two  ${UserData}

    RegistrationPage.Submit Form

    RegistrationPage.Security Question Error

    RegistrationPage.Select Specific Question  ${registration.form_question1}  ${UserData.second_question} 
    RegistrationPage.Select Specific Question  ${registration.form_question2}  ${UserData.second_question}

    RegistrationPage.Submit Form

    RegistrationPage.Security Question Error

    RegistrationPage.Choose Question One  ${UserData}
    RegistrationPage.Choose Question Two  ${UserData}

    RegistrationPage.Submit Form

    RegistrationPage.No Security Question Error

Password Length Error
    [Arguments]  ${UserData}

    RegistrationPage.Password Length Error  ${UserData}

Password Format Error
    [Arguments]  ${UserData}

    RegistrationPage.Password Format Error

Password Blank Error
    [Arguments]  ${UserData}

    RegistrationPage.Password Blank Error  ${UserData}

Enable 2FA
    [Arguments]

    RegistrationPage.Verify System User Login

    Grab Code
        ${qr} = Get Value  xpath://*[@class="QR-image"]

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

Assert User Logged In
    ProfileHome.Verify User Home Page

Delete User Profile
    [Arguments]  ${UserData}

    ProfileHome.Edit User Profile
    ProfileEdit.Verify Edit Page
    Run Keyword If  "${UserData.username}" == "robotapiuser"  ProfileEdit.Delete Profile With Missing Email
    ...  ELSE  ProfileEdit.Delete User Profile

Goto Edit User Profile Page
    ProfileHome.Edit User Profile

Edit User Profile
    [Arguments]  ${sex}  ${age}

    ProfileHome.Verify User Home Page
    ProfileHome.Edit User Profile
    ProfileEdit.Verify Edit Page
    ProfileEdit.Fill In Age Field  ${age}
    ProfileEdit.Select Gender  ${sex}
    ProfileEdit.Click Update
    ProfileHome.Verify User Home Page
    ProfileHome.Edit User Profile
    ProfileEdit.Check Age Field  ${age}
    ProfileEdit.Check Gender Field  ${sex}

Reset Edited Fields
    [Arguments]  ${sex}  ${age}

    ProfileEdit.Fill In Age Field  ${age}
    ProfileEdit.Select Gender  ${sex}
    ProfileEdit.Click Update

Update Security Questions

    ProfileHome.Verify User Home Page
    ProfileEdit.Edit User Profile
    ProfileEdit.Goto Update Questions Page
    UpdateQuestions.Verify Edit Questions Page
    UpdateQuestions.Select Question One
    UpdateQuestions.Fill In Answer Field One
    UpdateQuestions.Select Question Two
    UpdateQuestions.Fill In Answer Field Two
    UpdateQuestions.Click Update

Update User Password
    ProfileEdit.Goto Update Password Page
    UpdatePassword.Verify Password Page

Enter Old Password
    [Arguments]  ${UserData}

    UpdatePassword.Fill In Old Password  ${UserData}

Enter New Password
    [Arguments]  ${UserData}

    UpdatePassword.Fill In New Password  ${UserData}
    UpdatePassword.Click Update

Verify Password Reset Message
    ProfileEdit.Verify Password Update Msg

Assert Registration Errors
    RegistrationPage.Assert Field Errors

Check Password Reset Email
    PasswordReset.Check Reset Email

Open Password Update Page
    PasswordReset.Follow Reset Link

Goto Password Reset Page

    LandingPage.Load Landing Page
    LandingPage.Login
    LoginPage.Reset Password Link
    PasswordReset.Verify Reset Page Header

Reset Password Via Email
    [Arguments]  ${UserData}

    Goto Password Reset Page
    PasswordReset.Fill In Email  ${UserData}
    PasswordReset.Click Submit
    PasswordReset.Verify Reset Sent

Reset Password Via Questions
    [Arguments]  ${UserData}

    Goto Password Reset Page
    PasswordReset.Fill In Username  ${UserData}
    PasswordReset.Click Submit
    PasswordReset.Get Answer Field ID
    PasswordReset.Fill In Answer One  ${UserData}
    PasswordReset.Fill In Answer Two  ${UserData}
    PasswordReset.Click Submit
    PasswordReset.Fill In Password  ${UserData}
    PasswordReset.Fill In Password Confirmation  ${UserData}
    PasswordReset.Submit Password Reset

Reset Password Wrong Answers
    [Arguments]  ${UserData}

    Goto Password Reset Page
    PasswordReset.Fill In Username  ${UserData}
    PasswordReset.Click Submit
    PasswordReset.Get Answer Field ID
    PasswordReset.Fill In Answer One  ${UserData}
    PasswordReset.Fill In Answer Two  ${UserData}
    PasswordReset.Click Submit
    PasswordReset.Assert Incorrect Answer Message

Reset Password Invalid Username
    [Arguments]  ${UserData}

    Goto Password Reset Page
    PasswordReset.Fill In Username  ${UserData}
    PasswordReset.Click Submit

Reset Password Invalid Email
    [Arguments]  ${UserData}

    Goto Password Reset Page
    PasswordReset.Fill In Email  ${UserData}
    PasswordReset.Click Submit

Reset Password Submit Answers
    [Arguments]  ${UserData}

    Goto Password Reset Page
    PasswordReset.Fill In Username  ${UserData}
    PasswordReset.Click Submit
    PasswordReset.Get Answer Field ID
    PasswordReset.Fill In Answer One  ${UserData}
    PasswordReset.Fill In Answer Two  ${UserData}
    PasswordReset.Click Submit

Reset Password Submit Invalid Password
    [Arguments]  ${UserData}
    
    PasswordReset.Fill In Password  ${UserData}
    PasswordReset.Fill In Password Confirmation  ${UserData}
    PasswordReset.Submit Password Reset

Verify Django Success Page
    PasswordReset.Verify Django Page

Reset Password Lockout
    [Arguments]  ${UserData}

    Goto Password Reset Page

    PasswordReset.Fill In Username  ${UserData}
    PasswordReset.Click Submit

    PasswordReset.Get Answer Field ID

    Repeat Keyword  5  PasswordReset.Reset Lockout Error Steps  ${UserData}

    PasswordReset.Submit Answers  ${UserData}
    PasswordReset.Assert Lockout Message For Password Reset

    Goto Password Reset Page
    PasswordReset.Fill In Username  ${UserData}
    PasswordReset.Click Submit

    PasswordReset.Assert Lockout Message For Login

Complete Password Reset
    [Arguments]  ${UserData}

    PasswordReset.Generate End User Password
    PasswordReset.Verify Password Reset Form
    PasswordReset.Fill In Password  ${UserData}
    PasswordReset.Fill In Password Confirmation  ${UserData}
    PasswordReset.Submit Password Reset

Exceed Login Attempts
    [Arguments]  ${UserData}

    LandingPage.Load Landing Page
    LandingPage.Login
    Repeat Keyword  6  LoginPage.Fill In Form  ${UserData}
    LoginPage.Assert Max Login Error

Assert Existing User Error
    [Arguments]  ${UserData}  ${error.field}

    LandingPage.Load Landing Page
    LandingPage.Open Registration Form  ${UserData}
    RegistrationPage.Set No-validate

    Run Keyword If  "${UserData.type}" == "end-user"  RegistrationPage.First Registration Form Steps  ${UserData}
    ...  ELSE IF  "${UserData.type}" == "system-user"  RegistrationPage.Enter System User Fields  ${UserData}

    RegistrationPage.Submit Form
    RegistrationPage.Existing Credentials Error  ${error.field}

Assert Old Password Error
    UpdatePassword.Incorrect Old Password

Verify Password Mismatch
    PasswordReset.Mismatch Error

Verify Incorrect Answer Error
    PasswordReset.Assert Incorrect Answer Message

Password Match Error
    [Arguments]  ${UserData}
    
    RegistrationPage.Password Match Error  ${UserData}

Ensure User Locked Out
    LoginPage.Assert Max Login Error

Show Reset Sent Message
    PasswordReset.Verify Reset Sent

Load Localised Sites
    ProfileHome.Goto Afrikaans Site
    ProfileEdit.Verify Afrikaans Text
    Go Back
    ProfileHome.Goto German Site
    ProfileEdit.Verify German Text

Check Preselected Security Questions
    [Arguments]  ${UserData}

    Submit First End User Form  ${UserData}

    ${form_url} =  Catenate  ${AUTH_SERVICE_URL.${ENVIRONMENT}}/en/registration/?theme=springster&hide=end-user&question_ids=2&question_ids=4
    Go To  ${form_url}

    RegistrationPage.Verify Preselected Question Values And Text

Check Security Question Defaults
    [Arguments]  ${UserData}

    Submit First End User Form  ${UserData}

    ${form_url} =  Catenate  ${AUTH_SERVICE_URL.${ENVIRONMENT}}/en/registration/?theme=springster&hide=end-user
    Go To  ${form_url}

    RegistrationPage.Verify Preselected Question Defaults

Login Form Credential Validation
    [Arguments]  ${UserData}

    LandingPage.Load Landing Page
    LandingPage.Login
    RegistrationPage.Set No-validate
    LoginPage.Enter Auth Username  ${UserData}
    LoginPage.Enter Auth Password  ${UserData}
    LoginPage.Submit
    LoginPage.Verify Login Error  ${UserData}

Registration Form Credential Validation
    [Arguments]  ${UserData}

    Create New Profile  ${UserData}
    Verify Registration Error  ${UserData}

Create New Profile With Errors
    [Arguments]  ${UserData}

    LandingPage.Load Landing Page
    LandingPage.Open Registration Form  ${UserData}
    RegistrationPage.Set No-validate
    RegistrationPage.Verify Registration Form
    RegistrationPage.First Registration Form Steps  ${UserData}
