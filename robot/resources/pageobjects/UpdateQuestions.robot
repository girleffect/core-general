*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${profileedit.header} =  xpath://div[@id="title"]/h1
${profileedit.sex_select} =  xpath://select[@name="gender"]
${profileedit.age_select} =  xpath://input[@name="age"]
${profileedit.edit_btn} =  xpath://input[@type="submit"]
${profileedit.update_btn} =  xpath://input[@value="Update"]
${profileedit.update_pwd_btn} =  xpath://a[contains(text(), "Password update")]
${profileedit.questions_btn} =  xpath://a[contains(text(), "Security questions update")]
${profileedit.delete_lnk} =  xpath://a[contains(text(), "Delete account")]
${profileedit.delete_hdr} =  xpath://div[@id="title"]/h1
${profileedit.delete_freetext}=  xpath://textarea[@name="reason"]
${profileedit.delete_btn} =  xpath://input[@value="Delete account?"]
${profileedit.delete_confirm_txt} =  xpath://div[@id="content"]//p[@class="Intro"]
${profileedit.delete_confirm} =  name:confirmed_deletion
${profileedit.delete_deny} =  xpath://a[contains(text(), "No, I've changed my mind")]
${profileedit.delete_success} =  id:messagelist
${profileedit.logout_btn} =  xpath://a[contains(text(), "Logout")]
${profileedit.back_btn} =  xpath://a[contains(text(), "Back")]

*** Keywords ***

Verify Edit Page
    Wait Until Page Contains Element  ${profileedit.header}
    ELement Text Should Be  ${profileedit.header}  EDIT YOUR PROFILE

    Element Should Be Visible  ${profileedit.sex_select}
    Element Should Be Visible  ${profileedit.age_select}
    Element Should Be Visible  ${profileedit.edit_btn}
    Element Should Be Visible  ${profileedit.update_pwd_btn}
    Element Should Be Visible  ${profileedit.questions_btn}
    Element Should Be Visible  ${profileedit.logout_btn}

Logout
    Click Element  ${profileedit.logout_btn}

Edit Profile
    Click Element  ${profileedit.edit_btn}

Fill In Age Field
    Input Text  ${profileedit.age_select}  edit

Select Gender
    Select From List  ${profileedit.sex_select}  Female

Click Update
    Click Element  ${profileedit.update_btn}

Delete Profile
    Click Element  ${profileedit.delete_lnk}
    
    Wait Until Page Contains Element  ${profileedit.delete_hdr}
    Element Text Should Be  ${profileedit.delete_hdr}  DELETE YOUR ACCOUNT
    Element Should Be Visible  ${profileedit.delete_freetext}
    Element Should Be Visible  ${profileedit.back_btn}

    Input Text  ${profileedit.delete_freetext}  robotframework

    Click Element  ${profileedit.delete_btn}

    Wait Until Page Contains Element  ${profileedit.delete_confirm_txt}
    Element Text Should Be  ${profileedit.delete_confirm_txt}  We're sad to see you go. Are you sure you want to delete your account?  
    
    Element Should Be Visible  ${profileedit.delete_confirm}
    Element Should Be Visible  ${profileedit.delete_deny}

    Click Element  ${profileedit.delete_confirm}

    Wait Until Page Contains Element  ${profileedit.delete_success}
    Element Text Should Be  ${profileedit.delete_success}  Successfully requested account deletion.

