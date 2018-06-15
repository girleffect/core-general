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
${passwordreset.reset_txt}  id:content
${passwordreset.answer1}  xpath://*[@id="id_question_413"]
${passwordreset.answer2}  xpath://*[@id="id_question_414"]
${passwordreset.django_txt}  xpath://div[@id="content"]/p[1]

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

    Input Text  ${passwordreset.pwd2}  ${UserData.pwd_conf}

Fill In Answer One
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.answer1}  ${UserData.first_answer}

Fill In Answer Two
    [Arguments]  ${UserData}

    Input Text  ${passwordreset.answer2}  ${UserData.second_answer}

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
    Element Text Should Be  ${passwordreset.header}  PASSWORD RESET
    #Element Text Should Be  ${passwordreset.reset_txt}  Please enter your new password twice so we can verify you typed it in correctly.

    Element Should Be Visible  ${passwordreset.pwd1}
    Element Should Be Visible  ${passwordreset.pwd2}
    Element Should Be Visible  ${passwordreset.change_btn}

Submit Password Reset
    Click Element  ${passwordreset.change_btn}

Verify Django Page
    Wait Until Page Contains  Password reset complete
    Element Text Should Be  ${passwordreset.django_txt}  Your password has been set. You may go ahead and log in now.

Mismatch Error
    Wait Until Page Contains  The two password fields didn't match.
    Element Should Be Visible  ${passwordreset.pwd1}
    Element Should Be Visible  ${passwordreset.pwd2}

Supply Passwords
    [Documentation]  Created this to help with testing the reset lockout feature.
    [Arguments]  ${UserData}

    Fill In Password  ${UserData}
    Fill In Password Confirmation  ${UserData}
    Submit Password Reset

Assert Lockout Message For Login
    Wait Until Page Contains  You have exceeded the maximum number of allowed incorrect login attempts

Assert Lockout Message For Password Reset
    Wait Until Page Contains  You have exceeded the maximum number of allowed incorrect reset attempts

Assert Incorrect Answer Message
    Wait Until Page Contains  One or more answers are incorrect
    Element Should Be Visible  ${passwordreset.answer1}
    Element Should Be Visible  ${passwordreset.answer2}
