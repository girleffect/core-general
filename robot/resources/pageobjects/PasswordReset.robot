*** Settings ***
Library  SeleniumLibrary
Library  ImapLibrary

*** Variables ***
${passwordreset.header}  id:header
${passwordreset.back_btn}  xpath://a[@href="http://${URL.${ENVIRONMENT}}/oidc/callback/"]
${passwordreset.input}  name:email
${passwordreset.submit_btn}  xpath://*//input[@value="Submit"]
${passwordreset.pwd1}  id:id_new_password1
${passwordreset.pwd2}  id:id_new_password2
${passwordreset.change_btn}  xpath://*//input[@value="Change my password"]

*** Keywords ***

Fill In Email
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.input}  ${UserData.email}

Fill In Username
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.input}  ${UserData.username}

Fill In Password
Fill In Password Confirmation

Click Submit
    Click Button  Submit

Back To Landing Page
    Click Element  ${passwordreset.back_btn}

Verify Reset Page Header
    Wait Until Page Contains Element  ${passwordreset.header}
    Element Text Should Be  ${passwordreset.header}  FORGOT YOUR PASSWORD?

Verify Reset Sent
    
Check Reset Email
    Open Mailbox  server=imap.googlemail.com  user=jasonbarr.qa@gmail.com  password=letstest
    
    ${LATEST}=  Wait for Email  sender=auth@gehosting.org  timeout=120
    ${body}=  Get Email Body  ${LATEST}
    
    Should Contain  ${body}  Please go to the following page and choose a new password:
    Mark All Emails As Read
    Close Mailbox