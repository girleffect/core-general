*** Settings ***
Documentation  This is a set of tests for the Springster demo site.
Resource  ../resources/common.robot  # used for setup and teardown
Resource  ../resources/springster.robot  # stores lower level keywords used by test.
Resource  ../resources/API/girleffect_api.robot  # stores API level keywords.

#Suite Setup  Start Docker Container
Test Setup  Begin Web Test
Test Teardown  End Web Test
#Suite Teardown  Stop All Containers

*** Variables ***

${BROWSER} =  chrome
${START_URL} =  http://springster-example.qa-hub.ie.gehosting.org/
${GMP_URL} =  http://management-portal.qa-hub.ie.gehosting.org/#/login
${GMP_USERNAME} =  admin
${GMP_PASSWORD} =  Pae)b8So

*** Test Cases ***
Register as an end-user
    [Documentation]  Register as an end user.
    [Tags]  ready  end-user
    
    springster.Create User String
    springster.Register As User  end-user  ${RANDOM_USER}  ${RANDOM_PWD}

Login as an end-user
    [Documentation]  Login as the end user created above.
    [Tags]  ready  end-user

    springster.Login As User  end-user  ${RANDOM_USER}  ${RANDOM_PWD}
    springster.Authorise Registration

End user password validation - length
    [Documentation]  Verify end user pwd length requirement.
    [Tags]  ready  end-user

    springster.Create User String
    springster.Register As User  end-user  ${RANDOM_USER}  as
    springster.Password Length Error

End user password validation - blank
    [Documentation]  Verify end user pwd requirement.
    [Tags]  wip1  end-user

    springster.Create User String
    springster.Register As User  end-user  ${RANDOM_USER}  ${EMPTY}
    springster.Password Blank Error

Verify the fields shown on the end-user registration form.
    [Documentation]  The end user form should have different visible fields to the system user form.
    [Tags]  ready  end-user

    springster.Verify User Form Fields  end-user

De-activate end-user
    [Documentation]  De-activate an end-user and ensure they are blocked from accessing the site.
    [Tags]  ready  end-user  de-activate

    girleffect_api.Change User State  3f08f30e-5dc4-11e8-99a6-0242ac11000a  ${false}
    springster.Login As User  end-user  ROBOT  ${RANDOM_PWD}
    springster.Ensure Login Blocked

Re-activate end-user
    [Documentation]  Re-activate a previously blocked user and ensure they can login.
    [Tags]  ready  end-user  re-activate

    girleffect_api.Change User State  3f08f30e-5dc4-11e8-99a6-0242ac11000a  ${true}
    springster.Login As User  end-user  ROBOT  ${RANDOM_PWD}
    springster.Ensure Login Successful

End user registration with missing fields
    [Documentation]  WHEN a user does not complete the mandatory fields THEN the system should display an error message in red text
    [Tags]  end-user

Reset end-user pwd via security questions
    [Documentation]  End-user with no email address.
    [Tags]  end-user

End User submitting a request to delete their profile
    [Documentation]  GE-472. Check msisdn and email requirement.
    [Tags]  end-user

Each form question can only be picked once.
    [Documentation]  Ensure that users are not able to select a pwd question multiple times.
    [Tags]  ready

    springster.Registration Questions  end-user
    #springster.registration questions  system-user

Register as a system-user
    [Documentation]  Register as a system user.
    [Tags]  ready  system-user
    
    springster.Create User String
    springster.Register As User  system-user  ${RANDOM_USER}  ${RANDOM_PWD}

Login as a system-user
    [Documentation]  Login as the system user created above.
    [Tags]  ready  system-user

    springster.Login As User  system-user  ${RANDOM_USER}  ${RANDOM_PWD}

Verify the fields shown on the system-user registration form.
    [Documentation]  Verify that the correct system user fields are shown.
    [Tags]  ready  system-user

    springster.Verify User Form Fields  system-user

System user password validation - length
    [Documentation]  Verify system user pwd length requirement.
    [Tags]  wip

    springster.Create User String
    springster.Register As User  system-user  ${RANDOM_USER}  as
    springster.Password Length Error

Password confirmation doesn't match
    [Documentation]  Verify end user pwd requirement.
    [Tags]  wip1

    springster.Register As User  end-user  ${RANDOM_USER}  ${EMPTY}
    springster.Password Match Error

OIDC consent form - end user
    [Documentation]
    [Tags]

OIDC consent form - system user
    [Documentation]
    [Tags]

Edit Profile
    [Documentation]  
    [Tags]  

Edit lost password questions
    [Documentation]
    [Tags]

Reset end-user password with email address
    [Documentation]  
    [Tags]  

Reset system-user password with email address
    [Documentation]  
    [Tags] 

User with email address already exists
    [Documentation]  
    [Tags]  

Duplicate user email via GMP? 
    [Documentation]  When editing a user's details, enter already used email address.
    [Tags]

Reset system-user pwd via security questions
    [Documentation]  System-user with no email address.
    [Tags]

Exceed maximum login attempts
    [Documentation]
    [Tags]

#Provide consent as an adult user.
#    [Documentation]  If the user's age is older than 16, show the Ts & Cs. GE-430.
#    [Tags]

Check error message colour?
    [Documentation]  Is this even possible?
    [Tags]  validation

Assign user roles view GMP
    [Documentation]
    [Tags]

Assign site roles via GMP
    [Documentation]
    [Tags]
