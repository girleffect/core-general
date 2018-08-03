*** Settings ***
Library  SeleniumLibrary

*** Variables ***

${GMP_URL} =  https://management-portal.qa-hub.ie.gehosting.org/
${gmp.login_btn} =  xpath://*//span[1]
${gmp.login_username} =  name:auth-username 
${gmp.login_pwd} =  name:auth-password 
${gmp.logout} =  xpath://*//span[@class="logout"]
${gmp.users_lnk} =  xpath://*//span[@to="/users"]
${gmp.search} =  name:q
${gmp.column_id} =  xpath://*//td[@class="column-id"]  #//td[@class="column-id"]//span
${gmp.isactive_btn} =  xpath://*//div[@class="aor-input aor-input-is_active"]
${gmp.email_field} =  xpath://*//div[@class="aor-input aor-input-email"]
${gmp.msisdn_field} =  xpath://*//div[@class="aor-input aor-input-msisdn"]
${gmp.invitations_lnk} =  xpath://div[contains(text(), "Invitations")]
${gmp.create_invite_lnk} =  xpath://a[@href="#/invitations/create"]
#${gmp.edit_btn} =  xpath://a[#/users/${gmp.id}]

*** Keywords ***
Load GMP
    Open Browser  ${GMP_URL}  chrome
    Click Element  ${gmp.login_btn}
    Wait Until Page Contains  Login  timeout=20s
    Input Text  ${gmp.login_username}  ${GMP_USERNAME}
    Input Text  ${gmp.login_pwd}  ${GMP_PASSWORD}
    Click Button  Login

Find User
    [Arguments]  ${user}

    Wait Until Page Contains Element  ${gmp.users_lnk}  timeout=30s
    Click Element  ${gmp.users_lnk}
    Input Text  ${gmp.search}  ${user}
    Press Key  ${gmp.search}  \\0009

Toggle User Activation

    Wait Until Page Contains Element  xpath://*//tbody[@class="datagrid-body"]

    ${gmp.user_id} =  Get Text  ${gmp.column_id}
    Log  ${gmp.user_id}

    Click Element  xpath://td[@class="column-undefined"][1]
    Wait Until Page Contains  User Edit
    Click Element  ${gmp.isactive_btn}    

Save
    Click Button  Save

Create Invite

    Click Element  ${gmp.invitations_lnk}
    Click Element  ${gmp.create_invite_lnk}
    Wait Until Page Contains  Invitation Create

    
