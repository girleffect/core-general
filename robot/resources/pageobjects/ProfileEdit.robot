*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${profileedit.header} =  xpath://div[@id="title"]/h1
${profileedit.sex_select} =  xpath://select[@name="gender"]
${profileedit.age_select} =  xpath://input[@name="age"]
${profileedit.edit_btn} =  xpath://input[@type="submit"]
${profileedit.update_pwd_btn} =  xpath://a[@href="/en/profile/password/"]
${profileedit.questions_btn} =  xpath://a[@href="/en/profile/security/"]
${profileedit.delete_btn} =  xpath://a[@href="/en/profile/delete-account/"]
${profileedit.delete_hdr} =  xpath://div[@id="title"]/h1
${profileedit.delete_freetext}=  xpath://textarea[@name="reason"]
${profileedit.logout_btn} =  xpath://a[@href="/en/redirect/"]

*** Keywords ***

Verify Edit Page
    Wait Until Page Contains Element  ${profileedit.header}
    ELement Text Should Be  ${profileedit.header}  Edit Your Profile

    Element Should Be Visible  ${profileedit.sex_select}
    Element Should Be Visible  ${profileedit.age_select}
    Element Should Be Visible  ${profileedit.edit_btn}
    Element Should Be Visible  ${profileedit.update_pwd_btn}
    Element Should Be Visible  ${profileedit.questions_btn}

Logout
    Click Element  ${profileedit.logout_btn}

Edit Profile
    Click Element  ${profileedit.edit_btn}

Delete Profile
    Click Element  ${profileedit.delete_btn}
    
    Wait Until Page Contains Element  ${profileedit.delete_hdr}
    Element Text Should Be  ${profileedit.delete_hdr}  Delete Your Account
    Element Should Be Visible  ${profileedit.delete_freetext}

    Input Text  ${profileedit.delete_freetext}  robotframework

    Click Button  Delete Account?

