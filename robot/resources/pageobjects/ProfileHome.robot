*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${userhome.logout_btn} =  xpath://input[@value="Logout"]
${userhome.edit_btn} =  xpath://a[contains(text(), "Edit Profile")]

*** Keywords ***

Verify User Home Page
    Wait Until Page Contains Element  ${userhome.logout_btn}
    Wait Until Page Contains Element  ${userhome.edit_btn}

Logout
    Click Element  ${userhome.logout_btn}

Edit Profile
    Click Element  ${userhome.edit_btn}