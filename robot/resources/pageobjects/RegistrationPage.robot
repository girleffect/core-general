*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${header_txt} =  xpath://h1[contains(text(), "Registration")]
${registration.form_username} =  name:username
${registration.form_gender} =  name:gender
${registration.form_age} =  name:age
${registration.form_pwd1} =  name:password1
${registration.form_pwd2} =  name:password2
${registration.form_question1} =  name:form-0-question
${registration.form_answer1} =  name:form-0-answer
${registration.form_question2} =  name:form-1-question
${registration.form_answer2} =  name:form-1-answer

${registration.form_first} =  name:first_name
${registration.form_last} =  name:last_name
${registration.form_dob} =  name:dob
${registration.form_nickname} =  name:nickname
${registration.form_avatar} =  name:avatar
${registration.form_email} =  name:email
${registration.form_country} =  name:country
${registration.form_msisdn} =  name:msisdn
${registration_form.qr_code} =  xpath://*[@class="QR-image"]
${registration_form.terms} =  name:terms
${registration_form.tclink} =  xpath://a[@]
${registration_form.novalidate} =  var forms = document.querySelectorAll('.Form');for (var i = 0; i < forms.length; i++){forms[i].setAttribute('novalidate', false);}
${registration_form.username_error} =  xpath://*//div[@class="Field-item"]//li[1]
${registration_form.age_error} =  xpath://*/form/div[3]/div[1]/ul/li

*** Keywords ***
#TODO - Make granular keywords.

Set No-validate
    Execute Javascript  ${registration_form.novalidate}

Assert Field Errors
    Element Text Should Be  ${registration_form.age_error}  This field is required.
    Element Text Should Be  ${registration_form.username_error}  This field is required.

Enter Username Field
    [Arguments]  ${UserData}

    Input Text  ${registration.form_username}  ${UserData.username}

Enter First Name Field
    [Arguments]  ${UserData}
    
    Input Text  ${registration.form_first}  ${UserData.first}

Enter Last Name Field
    [Arguments]  ${UserData}
    
    Input Text  ${registration.form_last}  ${UserData.last}

Enter Email Field
    [Arguments]  ${UserData}
    
    Input Text  ${registration.form_email}  ${UserData.email}

Enter MSISDN Field
    [Arguments]  ${UserData}
    
    Input Text  ${registration.form_msisdn}  ${UserData.msisdn}

Enter Password Field
    [Arguments]  ${UserData}
    
    Input Text  ${registration.form_pwd1}  ${UserData.pwd}
    Input Text  ${registration.form_pwd2}  ${UserData.pwd}

Choose Gender From List
    [Arguments]  ${UserData}
    
    Select From List By Value  ${registration.form_gender}  ${UserData.gender}

Enter Age Field
    [Arguments]  ${UserData}
    
    Input Text  ${registration.form_age}  ${UserData.age}

Choose Question One
    [Arguments]  ${UserData}
    
    Select From List By Value  ${registration.form_question1}  ${UserData.first_question}

Choose Question Two
    [Arguments]  ${UserData}
    
    Select From List By Value  ${registration.form_question2}  ${UserData.second_question}

Enter Answer One
    [Arguments]  ${UserData}
    
    Input Text  ${registration.form_answer1}  ${UserData.first_answer}

Enter Answer Two
    [Arguments]  ${UserData}
    
    Input Text  ${registration.form_answer2}  ${UserData.second_answer}

Accept Terms
    Click Element  ${registration_form.terms}

Submit Form
    Click Button  Register  

Verify Registration Form
    #Wait Until Page Contains  Registration
    Wait Until Element Is Visible  ${header_txt} 

Enter User Details
    [Arguments]  ${UserData}

    Run Keyword If  "${UserData.type}" == "end-user"  Enter End User Fields  ${UserData}
    ...  ELSE IF  "${UserData.type}" == "system-user"  Enter System User Fields  ${UserData}

Verify User Fields
    [Arguments]  ${UserData}

    Run Keyword If  "${UserData.type}" == "end-user"  Verify End User Fields
    ...  ELSE IF  "${UserData.type}" == "system-user"  Verify System User Fields

Enable 2FA
    Verify System User Login

Grab Code
    Set Selenium Implicit Wait  5s
    Wait Until Page Contains Element  ${registration_form.qr_code}
    ${qr_img} =  Get WebElement  ${registration_form.qr_code}
    Log  ${qr_img}

Enter End User Fields
    [Arguments]  ${UserData}

    Input Text  ${registration.form_username}  ${UserData.username}
    Select From List By Value  ${registration.form_gender}  ${UserData.gender}
    Input Text  ${registration.form_age}  ${UserData.age}
    Input Text  ${registration.form_pwd1}  ${UserData.pwd}
    Input Text  ${registration.form_pwd2}  ${UserData.pwd}
    Select From List By Value  ${registration.form_question1}  ${UserData.first_question}
    Input Text  ${registration.form_answer1}  ${UserData.first_answer}
    Select From List By Value  ${registration.form_question2}  ${UserData.second_question}
    Input Text  ${registration.form_answer2}  ${UserData.second_answer}
    
    Click Element  ${registration_form.terms}

Enter System User Fields
    [Arguments]  ${UserData}

    Input Text  ${registration.form_username}  ${UserData.username}
    Input Text  ${registration.form_first}  Robot
    Input Text  ${registration.form_last}  Framework
    Input Text  ${registration.form_email}  ${UserData.email}
    Select From List By Value  ${registration.form_country}  ZA
    Input Text  ${registration.form_msisdn}  0712345678
    Select From List By Value  ${registration.form_gender}  ${UserData.gender}
    Input Text  ${registration.form_age}  ${UserData.age}
    Input Text  ${registration.form_pwd1}  ${UserData.pwd}
    Input Text  ${registration.form_pwd2}  ${UserData.pwd}
    Select From List By Value  ${registration.form_question1}  ${UserData.first_question}
    Input Text  ${registration.form_answer1}  ${UserData.first_answer}
    Select From List By Value  ${registration.form_question2}  ${UserData.second_question}
    Input Text  ${registration.form_answer2}  ${UserData.second_answer}
    
    Click Element  ${registration_form.terms}
    Submit Form
    #Enable 2FA
    #Grab Code

Verify System User Login
    Wait Until Page Contains  Enable Two-Factor Authentication
    Click Button  Next

Verify End User Fields
    # TODO - figure out a way to reduce this to a line of code.
    Element Should Be Visible  ${registration.form_username}
    Element Should Be Visible  ${registration.form_gender}
    Element Should Be Visible  ${registration.form_age}
    Element Should Be Visible  ${registration.form_pwd1}
    Element Should Be Visible  ${registration.form_pwd2}
    Element Should Be Visible  ${registration.form_question1}
    Element Should Be Visible  ${registration.form_answer1}
    Element Should Be Visible  ${registration.form_question2}
    Element Should Be Visible  ${registration.form_answer2}
    Element Should Be Visible  ${registration_form.terms}

    Element Should Not Be Visible  ${registration.form_first}
    Element Should Not Be Visible  ${registration.form_last}
    Element Should Not Be Visible  ${registration.form_dob}
    Element Should Not Be Visible  ${registration.form_nickname}
    Element Should Not Be Visible  ${registration.form_avatar}
    Element Should Not Be Visible  ${registration.form_email}
    Element Should Not Be Visible  ${registration.form_country}
    Element Should Not Be Visible  ${registration.form_msisdn}

Verify System User Fields
    Element Should Be Visible  ${registration.form_username}
    Element Should Be Visible  ${registration.form_gender}
    Element Should Be Visible  ${registration.form_age}
    Element Should Be Visible  ${registration.form_pwd1}
    Element Should Be Visible  ${registration.form_pwd2}
    Element Should Be Visible  ${registration.form_question1}
    Element Should Be Visible  ${registration.form_answer1}
    Element Should Be Visible  ${registration.form_question2}
    Element Should Be Visible  ${registration.form_answer2}
    Element Should Be Visible  ${registration_form.terms}
    Element Should Be Visible  ${registration.form_first}
    Element Should Be Visible  ${registration.form_last}
    #Element Should Be Visible  ${registration.form_dob}
    #Element Should Be Visible  ${registration.form_avatar}
    Element Should Be Visible  ${registration.form_email}
    Element Should Be Visible  ${registration.form_country}
    Element Should Be Visible  ${registration.form_msisdn}

    Element Should Not Be Visible  ${registration.form_nickname}

Question Usage
    [Arguments]  ${UserData}
    
    #TODO - Refactor to use enter end-user function.
    Input Text  ${registration.form_username}  ${UserData.username}
    Select From List By Value  ${registration.form_gender}  ${UserData.gender}
    Input Text  ${registration.form_age}  ${UserData.age}
    Input Text  ${registration.form_pwd1}  ${UserData.pwd}
    Input Text  ${registration.form_pwd2}  ${UserData.pwd}
    Select From List By Value  ${registration.form_question1}  ${UserData.first_question}
    Input Text  ${registration.form_answer1}  ${UserData.first_answer}
    Select From List By Value  ${registration.form_question2}  ${UserData.first_question}
    Input Text  ${registration.form_answer2}  ${UserData.second_answer}

    Click Element  ${registration_form.terms}

    Submit Form

    Page Should Contain  Each question can only be picked once.

    Input Text  ${registration.form_pwd1}  ${UserData.pwd}
    Input Text  ${registration.form_pwd2}  ${UserData.pwd}

    Select From List By Value  ${registration.form_question1}  ${UserData.second_question} 
    Select From List By Value  ${registration.form_question2}  ${UserData.second_question}

    Submit Form

    Page Should Contain  Each question can only be picked once.

    Input Text  ${registration.form_pwd1}  ${UserData.pwd}
    Input Text  ${registration.form_pwd2}  ${UserData.pwd}

    Select From List By Value  ${registration.form_question1}  ${UserData.first_question}
    Select From List By Value  ${registration.form_question2}  ${UserData.second_question}

    Submit Form

    Page Should Not Contain  Each question can only be picked once.
    
Password Length Error
    Set Selenium Implicit Wait  5s
    
    Run Keyword If  "${type}" == "end-user"  Wait Until Page Contains  Password not long enough.
    ...  ELSE IF  "${type}" == "system-user"  Wait Until Page Contains  This password is too short. It must contain at least 8 characters.

#The password must contain at least one uppercase letter, one lowercase one, a digit and special character.

Existing Credentials Error
    [Arguments]  ${error.field}

    Run Keyword If  "${error.field}" == "email"  Wait Until Page Contains  Core user with this Email address already exists.
    ...  ELSE IF  "${error.field}" == "username"  Wait Until Page Contains  A user with that username already exists.




