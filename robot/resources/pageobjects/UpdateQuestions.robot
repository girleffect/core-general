*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${updatequestions.header} =  xpath://div[@id="title"]/h1
${updatequestions.question1} =  id:id_form-0-question
${updatequestions.answer1} =  id:id_form-0-answer
${updatequestions.question2} =  id:id_form-1-question
${updatequestions.answer2} =  id:id_form-1-answer
${updatequestions.update_pwd_btn} =  xpath://input[@value="Update"]
${updatequestions.back_btn} =  xpath://a[contains(text(), "Back")]

*** Keywords ***

Verify Edit Questions Page
    Wait Until Page Contains Element  ${updatequestions.header}
    Element Text Should Be  ${updatequestions.header}  UPDATE SECURITY QUESTIONS

    Element Should Be Visible  ${updatequestions.question1}
    Element Should Be Visible  ${updatequestions.answer1}
    Element Should Be Visible  ${updatequestions.question2}
    Element Should Be Visible  ${updatequestions.answer2}
    Element Should Be Visible  ${updatequestions.update_pwd_btn}
    Element Should Be Visible  ${updatequestions.back_btn}

Logout
    Click Element  ${updatequestions.logout_btn}

Edit Profile
    Click Element  ${updatequestions.edit_btn}

Fill In Age Field
    Input Text  ${updatequestions.age_select}  edit

Select Gender
    Select From List  ${updatequestions.sex_select}  Female

Click Update
    Click Element  ${updatequestions.update_btn}

Delete Profile
    Click Element  ${updatequestions.delete_lnk}
    
    Wait Until Page Contains Element  ${updatequestions.delete_hdr}
    Element Text Should Be  ${updatequestions.delete_hdr}  DELETE YOUR ACCOUNT
    Element Should Be Visible  ${updatequestions.delete_freetext}
    Element Should Be Visible  ${updatequestions.back_btn}

    Input Text  ${updatequestions.delete_freetext}  robotframework

    Click Element  ${updatequestions.delete_btn}

    Wait Until Page Contains Element  ${updatequestions.delete_confirm_txt}
    Element Text Should Be  ${updatequestions.delete_confirm_txt}  We're sad to see you go. Are you sure you want to delete your account?  
    
    Element Should Be Visible  ${updatequestions.delete_confirm}
    Element Should Be Visible  ${updatequestions.delete_deny}

    Click Element  ${updatequestions.delete_confirm}

    Wait Until Page Contains Element  ${updatequestions.delete_success}
    Element Text Should Be  ${updatequestions.delete_success}  Successfully requested account deletion.

