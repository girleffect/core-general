*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${header_txt} =  xpath://h1[contains(text(), "Registration")]
${registration.form_username} =  name:userdata-username
${registration.form_gender} =  name:userdata-gender
${registration.form_age} =  name:userdata-age
${registration.form_pwd1} =  name:userdata-password1
${registration.form_pwd2} =  name:userdata-password2
${registration.form_question1} =  name:securityquestions-0-question
${registration.form_answer1} =  name:securityquestions-0-answer
${registration.form_question2} =  name:securityquestions-1-question
${registration.form_answer2} =  name:securityquestions-1-answer
## System User Fields ##
${registration.form_first} =  name:userdata-first_name
${registration.form_last} =  name:userdata-last_name
${registration.form_dob} =  name:userdata-dob
${registration.form_nickname} =  name:userdata-nickname
${registration.form_avatar} =  name:userdata-avatar
${registration.form_email} =  name:userdata-email
${registration.form_country} =  name:userdata-country
${registration.form_msisdn} =  name:userdata-msisdn
${registration_form.qr_code} =  xpath://*[@class="QR-image"]
##
${registration_form.terms} =  name:userdata-terms
${registration_form.tclink} =  xpath://a[@]
${registration_form.novalidate} =  var forms = document.querySelectorAll('.Form');for (var i = 0; i < forms.length; i++){forms[i].setAttribute('novalidate', false);}
${registration_form.username_error} =  xpath://*//div[@class="Field-item"]//li[1]
${registration_form.age_error} =  xpath://*/form/div[3]/div[1]/ul/li
${registration_form.pwd1_error} =  xpath://*[@id="content"]/form/div[4]/div[1]/ul/li
${registration_form.pwd2_error} =  xpath://*[@id="content"]/form/div[5]/div[1]/ul/li
${registration_form.success} =  id:title
${registration_form.success_msg} =  id:content
${registration_form.submit} =  name:submit
${registration_form.back_btn} =  name:wizard_goto_step

*** Keywords ***

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

Enter Password Fields
    [Arguments]  ${UserData}
    
    Input Text  ${registration.form_pwd1}  ${UserData.pwd}
    Input Text  ${registration.form_pwd2}  ${UserData.pwd_conf}

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
    Click Button  Submit
    #Click Element  ${registration_form.submit}

Verify Registration Form
    #Wait Until Page Contains  Registration
    Wait Until Element Is Visible  ${header_txt} 

Enter User Details
    [Arguments]  ${UserData}

    Run Keyword If  "${UserData.type}" == "end-user"  Enter End User Fields  ${UserData}
    ...  ELSE IF  "${UserData.type}" == "system-user"  Enter System User Fields  ${UserData}

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
    Input Text  ${registration.form_pwd2}  ${UserData.pwd_conf}
    Click Element  ${registration_form.terms}
    # Click Submit To Go To Second Step
    #Click Element  ${registration_form.submit}
    Click Button  Submit
    Select From List By Value  ${registration.form_question1}  ${UserData.first_question}
    Input Text  ${registration.form_answer1}  ${UserData.first_answer}
    Select From List By Value  ${registration.form_question2}  ${UserData.second_question}
    Input Text  ${registration.form_answer2}  ${UserData.second_answer}
    
    Element Should Be Visible  ${registration_form.back_btn}

First Registration Form Steps
    [Arguments]  ${UserData}

    Input Text  ${registration.form_username}  ${UserData.username}
    Select From List By Value  ${registration.form_gender}  ${UserData.gender}
    Input Text  ${registration.form_age}  ${UserData.age}
    Input Text  ${registration.form_pwd1}  ${UserData.pwd}
    Input Text  ${registration.form_pwd2}  ${UserData.pwd_conf}
    Click Element  ${registration_form.terms}
    # Click Submit To Go To Second Step
    Click Button  Submit
    #Click Element  ${registration_form.submit}

Enter System User Fields
    [Arguments]  ${UserData}

    Input Text  ${registration.form_username}  ${UserData.username}
    Input Text  ${registration.form_first}  ${UserData.fname}
    Input Text  ${registration.form_last}  ${UserData.lname}
    Input Text  ${registration.form_email}  ${UserData.email}
    Select From List By Value  ${registration.form_country}  ${UserData.country}
    Input Text  ${registration.form_msisdn}  ${UserData.msisdn}
    Select From List By Value  ${registration.form_gender}  ${UserData.gender}
    Input Text  ${registration.form_age}  ${UserData.age}
    Input Text  ${registration.form_pwd1}  ${UserData.pwd}
    Input Text  ${registration.form_pwd2}  ${UserData.pwd_conf}

    Click Element  ${registration_form.terms}
    #Click Button  Submit

    # Only ask for security questions
    #Select From List By Value  ${registration.form_question1}  ${UserData.first_question}
    #Input Text  ${registration.form_answer1}  ${UserData.first_answer}
    #Select From List By Value  ${registration.form_question2}  ${UserData.second_question}
    #Input Text  ${registration.form_answer2}  ${UserData.second_answer}

Password Match Error
    [Arguments]  ${UserData}

    Wait Until Element Contains  ${registration_form.pwd2_error}  ${UserData.error}

Password Length Error
    [Arguments]  ${UserData}

    Set Selenium Implicit Wait  5s
    
    Run Keyword If  "${UserData.type}" == "end-user"  Wait Until Page Contains  ${UserData.error}
    ...  ELSE IF  "${UserData.type}" == "system-user"  Wait Until Page Contains  This password is too short. It must contain at least 8 characters.
    #The password must contain at least one uppercase letter, one lowercase one, a digit and special character.

Password Blank Error
    [Arguments]  ${UserData}

    Wait Until Element Contains  ${registration_form.pwd1_error}  ${UserData.error}
    Wait Until Element Contains  ${registration_form.pwd2_error}  ${UserData.error}

Password Format Error
    Log  This isn't ready yet...

Existing Credentials Error
    [Arguments]  ${error.field}

    Run Keyword If  "${error.field}" == "email"  Wait Until Page Contains  Core user with this Email address already exists.
    ...  ELSE IF  "${error.field}" == "username"  Wait Until Page Contains  A user with that username already exists.

Verify Registration Successful
    Element Text Should Be  ${registration_form.success}  REGISTRATION SUCCESS
    Element Text Should Be  ${registration_form.success_msg}  Congratulations, you have successfully registered for a Girl Effect account.

Verify Preselected Question Values And Text
    List Selection Should Be  ${registration.form_question1}  2
    List Selection Should Be  ${registration.form_question2}  4

Verify Preselected Question Defaults
    List Selection Should Be  ${registration.form_question1}  ${EMPTY}
    List Selection Should Be  ${registration.form_question2}  ${EMPTY}

Go Back To First Step
    Click Element  ${registration_form.back_btn}

Select Specific Question
    [Arguments]  ${question.field}  ${question.value}

    Select From List By Value  ${question.field}  ${question.value}

Security Question Error
    Page Should Contain  Each question can only be picked once.

No Security Question Error
    Page Should Not Contain  Each question can only be picked once.