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
${passwordreset.change_msg}  xpath://div[@id="content"]/p[1]

*** Keywords ***

Fill In Email
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.input}  ${UserData.email}

Fill In Username
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.input}  ${UserData.username}

Fill In Password
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.pwd1}  ${UserData.password}

Fill In Password Confirmation
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.pwd2}  ${UserData.password}

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
    Set Variable  ${link}

Open Password Change Page
    Click Link  ${link}