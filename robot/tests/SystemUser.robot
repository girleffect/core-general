*** Settings ***
Documentation  This is a set of tests for the actions related to system users.
Resource  ../resources/common.robot  # used for setup and teardown
Resource  ../resources/springster.robot  # stores lower level keywords used by test.
Resource  ../resources/API/girleffect_api.robot  # stores API level keywords.

#Suite Setup  Start Docker Container
Test Setup  Run Keywords  Begin Web Test
Test Teardown  End Web Test
#Suite Teardown  Stop All Containers

*** Variables ***

${ENVIRONMENT} =  qa
${BROWSER} =  chrome
&{URL}  local=http://localhost:8000  qa=http://springster-example.qa-hub.ie.gehosting.org/
&{GMP_URL}  local=http://localhost:8000  qa=http://management-portal.qa-hub.ie.gehosting.org/#/login
${GMP_USERNAME} =  admin
${GMP_PASSWORD} =  Pae)b8So
&{API_USER}  id=3d0bd676-6246-11e8-94fc-0242ac110007  username=robot  pwd=SDF45!@
&{SYS_USER_INVALID}  type=end-user  username=${EMPTY}  pwd=password  age=${EMPTY}  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{SYS_USER_VALID}  type=end-user  username=robotframework2  pwd=SDF45!@  email=jasonbarr.qa@gmail.com  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2

*** Test Cases ***
Create new system user profile
    [Documentation]  Register as a system user.
    [Tags]  ready  system-user
    
    springster.Generate User Name
    springster.Register As User  ${SYS_USER_VALID}

Login as a new system user
    [Documentation]  Login as the system user created above.
    [Tags]  ready  system-user

    springster.Login As User  ${SYS_USER_VALID}

Logout as system user
    [Documentation]
    [Tags]  ready  system-user

    springster.Login As User  ${SYS_USER_VALID}
    springster.Assert User Logged In
    springster.Logout

    # If logout is successful the user will be taken to the Springster Demo Example Home Page.
    springster.Assert Landing Page Header

Verify the fields shown on the system-user registration form.
    [Documentation]  Verify that the correct system user fields are shown.
    [Tags]  ready  system-user

    springster.Verify User Form Fields  ${SYS_USER_VALID}

System user password validation - length
    [Documentation]  Verify system user pwd length requirement.
    [Tags]  wip1

    springster.Generate User Name
    springster.Register As User  ${SYS_USER_INVALID}
    springster.Password Length Error

Password confirmation doesn't match
    [Documentation]  Verify end user pwd requirement.
    [Tags]  wip1

    springster.Register As User  ${END_USER_INVALID}
    springster.Password Match Error

OIDC consent form - end user
    [Documentation]
    [Tags]

OIDC consent form - system user
    [Documentation]
    [Tags]

Reset system user password via email
    [Documentation]  
    [Tags]  

    # Add email address via API PUT request.
    girleffect_api.Change User State  ${END_USER_VALID}  user@example.com
    springster.Lost Password  ${END_USER_VALID}

    #girleffect_api.Change User State  ${END_USER_VALID}  user@example.com
    #springster.Lost Password  ${END_USER_VALID}

Reset system user password questions
    [Documentation]  
    [Tags] 

    # Add email address via API PUT request.
    girleffect_api.Change User State  ${SYS_USER_VALID}  ${EMPTY}
    springster.Lost Password  ${SYS_USER_VALID}

    #girleffect_api.Change User State  ${END_USER_VALID}  user@example.com
    #springster.Lost Password  ${END_USER_VALID}

Exceed maximum login attempts
    [Documentation]
    [Tags]

    springster.Exceed Login Attempts end-user  ${END_USER_VALID} 

Assign system user roles view GMP
    [Documentation]
    [Tags]

    # Probably best to do this via API and then check the FE?

Assign site roles via GMP

    [Documentation]
    [Tags]

    # Probably best to do this via API and then check the FE?

Site/theme de-activation.
    [Documentation]
    [Tags]

Update questions via auth admin/gmp.

    [Documentation]
    [Tags]
