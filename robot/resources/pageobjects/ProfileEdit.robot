*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${profileedit.header} =  xpath://div[@id="title"]/h1
${profileedit.sex_select} =  xpath://select[@name="gender"]
${profileedit.age_select} =  name:age  #xpath://input[@name="age"]
${profileedit.edit_btn} =  xpath://a[contains(text(), "Edit Profile")]
${profileedit.update_btn} =  xpath://input[@value="Update"]
${profileedit.update_pwd_lnk} =  xpath://a[contains(text(), "Password update")]
${profileedit.questions_lnk} =  xpath://a[contains(text(), "Security questions update")]
${profileedit.delete_lnk} =  xpath://a[contains(text(), "Delete account")]
${profileedit.delete_hdr} =  xpath://div[@id="title"]/h1
${profileedit.delete_freetext}=  xpath://textarea[@name="reason"]
${profileedit.delete_btn} =  xpath://input[@value="Delete account?"]
${profileedit.delete_confirm_txt} =  xpath://div[@id="content"]//p[@class="Intro"]
${profileedit.delete_confirm} =  name:confirmed_deletion
${profileedit.delete_deny} =  xpath://a[contains(text(), "No, I've changed my mind")]
${profileedit.messagelist} =  id:messagelist
${profileedit.logout_lnk} =  xpath://a[contains(text(), "Logout")]
${profileedit.back_lnk} =  xpath://a[contains(text(), "Back")]
${profileedit.avatar} =  xpath://label[@for="id_avatar"]

*** Keywords ***

Verify Edit Page
    Wait Until Page Contains Element  ${profileedit.header}
    Element Text Should Be  ${profileedit.header}  EDIT YOUR PROFILE

    Element Should Be Visible  ${profileedit.sex_select}
    Element Should Be Visible  ${profileedit.age_select}
    Element Should Be Visible  ${profileedit.update_btn}
    Element Should Be Visible  ${profileedit.avatar}
    Element Should Be Visible  ${profileedit.update_pwd_lnk}
    Element Should Be Visible  ${profileedit.questions_lnk}
    Element Should Be Visible  ${profileedit.logout_lnk}

Logout
    Click Element  ${profileedit.logout_lnk}

Fill In Age Field
    [Arguments]  ${age}

    Input Text  ${profileedit.age_select}  ${age}

Check Age Field
    [Arguments]  ${age}

    ${edited_age} =  Get Value  ${profileedit.age_select}
    Should Be Equal As Strings  ${edited_age}  ${age}

Select Gender
    [Arguments]  ${sex}

    Select From List By Value  ${profileedit.sex_select}  ${sex}

Check Gender Field
    [Arguments]  ${sex}

    ${edited_sex} =  Get Selected List Value  ${profileedit.sex_select}
    Should Be Equal As Strings  ${edited_sex}  ${sex}

Click Update
    Click Element  ${profileedit.update_btn}

Delete User Profile
    Click Element  ${profileedit.delete_lnk}
    
    Wait Until Page Contains Element  ${profileedit.delete_hdr}
    Element Text Should Be  ${profileedit.delete_hdr}  DELETE YOUR ACCOUNT
    Element Should Be Visible  ${profileedit.delete_freetext}
    Element Should Be Visible  ${profileedit.back_lnk}

    Input Text  ${profileedit.delete_freetext}  robotframework

    Click Element  ${profileedit.delete_btn}

    Wait Until Page Contains Element  ${profileedit.delete_confirm_txt}
    Element Text Should Be  ${profileedit.delete_confirm_txt}  We're sad to see you go. Are you sure you want to delete your account?  
    
    Element Should Be Visible  ${profileedit.delete_confirm}
    Element Should Be Visible  ${profileedit.delete_deny}

    Click Element  ${profileedit.delete_confirm}

    Wait Until Page Contains Element  ${profileedit.messagelist}
    Element Text Should Be  ${profileedit.messagelist}  Successfully requested account deletion.

Delete Profile With Missing Email
    Click Element  ${profileedit.delete_lnk}
    
    Wait Until Page Contains Element  ${profileedit.delete_hdr}
    Element Text Should Be  ${profileedit.delete_hdr}  DELETE YOUR ACCOUNT
    #Element Text Should Be  ${profileedit.messagelist}  You require either an email or msisdn to request an account deletion

Goto Update Questions Page
    Click Element  ${profileedit.questions_lnk}

Goto Update Password Page
    Click Element  ${profileedit.update_pwd_lnk}

Verify Password Update Msg
    Wait Until Page Contains Element  ${profileedit.messagelist}
    Element Text Should Be  ${profileedit.messagelist}  Successfully updated password.

Verify Afrikaans Text
    Element Text Should Be  xpath://*[@id="content"]/form/div[4]/ul/li[1]/a  Opdateer wagwoord
    Element Text Should Be  xpath://*[@id="content"]/form/div[4]/ul/li[2]/a  Veiligheidsvraagopdatering
    Element Text Should Be  xpath://*[@id="content"]/form/div[4]/ul/li[3]/a  Skrap rekening

Verify German Text
    Element Text Should Be  xpath://*[@id="content"]/form/div[4]/ul/li[1]/a  Passwort aktualisieren
    Element Text Should Be  xpath://*[@id="content"]/form/div[4]/ul/li[2]/a  Sicherheitsfragen aktualisieren
    Element Text Should Be  xpath://*[@id="content"]/form/div[4]/ul/li[3]/a  Konto löschen