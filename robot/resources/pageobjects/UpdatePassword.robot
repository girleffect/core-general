*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${updatepassword.header} =  xpath://div[@id="title"]
${updatepassword.old_pwd} =  id:id_old_password
${updatepassword.new_pwd1} =  id:id_new_password1
${updatepassword.new_pwd2} =  id:id_new_password2
${updatepassword.update_btn} =  xpath://input[@value="Update"]
${updatepassword.back_lnk} =  xpath://a[contains(text(), "Back")]

*** Keywords ***

Verify Password Page
    Wait Until Page Contains Element  ${updatepassword.header}
    Wait Until Page Contains  Update Your Password
    #Element Text Should Be  ${updatepassword.header}  UPDATE YOUR PASSWORD

    Element Should Be Visible  ${updatepassword.old_pwd}
    Element Should Be Visible  ${updatepassword.new_pwd1}
    Element Should Be Visible  ${updatepassword.new_pwd2}
    Element Should Be Visible  ${updatepassword.update_btn}
    Element Should Be Visible  ${updatepassword.back_lnk}

Fill In Old Password
    [Arguments]  ${UserData}

    Input Text  ${updatepassword.old_pwd}  ${Userdata.pwd}

Fill In New Password
    [Arguments]  ${UserData}
    
    # TODO - test case for if these don't match.

    Input Text  ${updatepassword.new_pwd1}  ${UserData.pwd}
    Input Text  ${updatepassword.new_pwd2}  ${UserData.pwd}

Click Update
    Click Element  ${updatepassword.update_btn}