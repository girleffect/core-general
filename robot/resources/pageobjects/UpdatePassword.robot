*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${updatepassword.header} =  xpath://div[@id="title"]/h1
${updatepassword.old_pwd} =  id:id_old_password
${updatepassword.new_pwd1} =  id:id_new_password1
${updatepassword.new_pwd2} =  id:id_new_password2
${updatepassword.update_btn} =  xpath://input[@value="Update"]
${updatepassword.back_lnk} =  xpath://a[contains(text(), "Back")]

*** Keywords ***

Verify Password Page
    Wait Until Page Contains Element  ${updatepassword.header}
    ELement Text Should Be  ${updatepassword.header}  UPDATE YOUR PASSWORD

    Element Should Be Visible  ${updatepassword.old_pwd}
    Element Should Be Visible  ${updatepassword.new_pwd1}
    Element Should Be Visible  ${updatepassword.new_pwd2}
    Element Should Be Visible  ${updatepassword.update_btn}
    Element Should Be Visible  ${updatepassword.back_lnk}

Fill In Old Password
    [Arguments]  ${UserData}

    Input Text  ${updatepassword.old_pwd}  ${Userdata.pwd}

Fill In New Password
    # TODO - test case for if these don't match.

    Input Text  ${updatepassword.new_pwd1}  asdfgh
    Input Text  ${updatepassword.new_pwd2}  asdfgh

Click Update
    Click Element  ${updatepassword.update_btn}