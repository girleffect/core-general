*** Settings ***
Library  SeleniumLibrary
Library  ImapLibrary
Library  String

*** Variables ***
${passwordreset.header}  id:title
${passwordreset.back_btn}  xpath://a[@href="http://${URL.${ENVIRONMENT}}/oidc/callback/"]
${passwordreset.input}  name:email
${passwordreset.submit_btn}  xpath://*//input[@value="Submit"]
${passwordreset.pwd1}  id:id_new_password1
${passwordreset.pwd2}  id:id_new_password2
${passwordreset.change_btn}  xpath://*//input[@value="Change my password"]
${passwordreset.reset_hdr}  id:content

*** Keywords ***
Generate End User Password
    ${UserData.pwd} =  Generate Random String  5

Fill In Email
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.input}  ${UserData.email}

Fill In Username
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.input}  ${UserData.username}

Fill In Password
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.pwd1}  ${UserData.pwd}

Fill In Password Confirmation
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.pwd2}  ${UserData.pwd}

Click Submit
    Click Button  Submit

Back To Landing Page
    Click Element  ${passwordreset.back_btn}

Verify Reset Page Header
    Wait Until Page Contains Element  ${passwordreset.header}
    Element Text Should Be  ${passwordreset.header}  FORGOT YOUR PASSWORD?

Verify Reset Sent
    Wait Until Page Contains  We've emailed you instructions for setting your password, if an account exists with the email you entered. You should receive them shortly.

Check Reset Email
    Open Mailbox  server=imap.googlemail.com  user=jasonbarr.qa@gmail.com  password=letstest
    
    ${LATEST}=  Wait for Email  sender=auth@gehosting.org  timeout=120
    ${body}=  Get Email Body  ${LATEST}

    Should Contain  ${body}  Please go to the following page and choose a new password:
    Mark All Emails As Read
    Close Mailbox

    # Pass the password reset link to a variable:
    ${link} =  Get Lines Matching Pattern  ${body}  https://authentication-service.qa-hub.ie.gehosting.org*
    Set Global Variable  ${link}

Follow Reset Link
    Go To  ${link}

Verify Password Reset Form
    Element Text Should Be  ${passwordreset.reset_hdr}  Please enter your new password twice so we can verify you typed it in correctly.

Submit Password Reset
    Click Element  ${passwordreset.change_btn}
