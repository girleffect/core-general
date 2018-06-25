*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${userhome.logout_btn} =  xpath://input[@value="Logout"]
${userhome.edit_btn} =  xpath://a[contains(text(), "Edit Profile")]
${userhome.afrikaans} =  //div[@class="submit"][2]
${userhome.german} =  //div[@class="submit"][3]
${userhome.lang_hdr} =  //*[@id="wagtail"]/div/div/div/h2

*** Keywords ***

Verify User Home Page
    Wait Until Page Contains Element  ${userhome.logout_btn}
    Wait Until Page Contains Element  ${userhome.edit_btn}
    Wait Until Page Contains Element  ${userhome.afrikaans}
    Wait Until Page Contains Element  ${userhome.german}

Logout
    Click Element  ${userhome.logout_btn}

Edit User Profile
    Click Element  ${userhome.edit_btn}

Language Header
    Element Text Should Be  ${userhome.lang_hdr}  Try out different languages on the Authentication Service.

Goto Afrikaans Site
    Click Element  ${userhome.afrikaans}

Goto German Site
    Click Link  German
