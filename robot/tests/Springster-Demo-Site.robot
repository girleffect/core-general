*** Settings ***
Documentation  This is a set of tests for the Springster demo site.
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
&{END_USER_INVALID}  type=end-user  username=${EMPTY}  pwd=password  age=${EMPTY}  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_VALID}  type=end-user  username=robotframework1  pwd=SDF45!@  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{API_USER}  id=3d0bd676-6246-11e8-94fc-0242ac110007  username=robot  pwd=SDF45!@

*** Test Cases ***
Create new end user profile
    [Documentation]  Register as an end user.
    [Tags]  ready  end-user  new

    springster.Create New Profile  ${END_USER_VALID}

Login as a new end-user
    [Documentation]  Login as the end user created above.
    [Tags]  ready  end-user  login

    springster.Login As User  ${END_USER_VALID}
    springster.Authorise Registration
    springster.Assert User Logged In

Logout as end user
    [Documentation]
    [Tags]  ready  end-user  logout

    springster.Login As User  ${END_USER_VALID}
    springster.Assert User Logged In
    springster.Logout

    # If logout is successful the user will be taken to the Springster Demo Example Home Page.
    springster.Assert Landing Page Header

Delete user
    [Documentation]  Delete the end user created above.
    [Tags]  ready  end-user  delete

    springster.Delete User Profile  ${END_USER_VALID}

End user password validation - length
    [Documentation]  Verify end user pwd length requirement.
    [Tags]  ready  end-user

    springster.Generate User Name
    springster.Register As User  ${END_USER_}
    springster.Password Length Error

End user password validation - blank
    [Documentation]  Verify end user pwd requirement.
    [Tags]  wip1  end-user

    springster.Generate User Name
    springster.Register As User  end-user  ${RND_USER}  ${EMPTY}
    springster.Password Blank Error

Verify the fields shown on the end-user registration form.
    [Documentation]  The end user form should have different visible fields to the system user form.
    [Tags]  ready  end-user

    springster.Verify User Form Fields  end-user

De-activate end user
    [Documentation]  De-activate an end-user and ensure they are blocked from accessing the site.
    [Tags]  ready  end-user  de-activate

    girleffect_api.Change User State  ${API_USER}  ${false}
    springster.Login As User  ${API_USER}
    springster.Ensure Login Blocked

Re-activate end user
    [Documentation]  Re-activate a previously blocked user and ensure they can login.
    [Tags]  ready  end-user  re-activate

    girleffect_api.Change User State  ${API_USER}  ${true}
    springster.Login As User  ${API_USER}
    springster.Assert User Logged In

End user registration with missing fields
    [Documentation]  WHEN a user does not complete the mandatory fields THEN the system should display an error message in red text
    [Tags]  end-user  copy

    springster.Generate User Name
    springster.Create New Profile  ${END_USER_INVALID}
    springster.Assert Registration Errors

Reset end user pwd via security questions
    [Documentation]  End-user with no email address.
    [Tags]  end-user

    # Reset steps here...
    springster.Login As User  end-user  ROBOT  ${RND_PWD}
    springster.Ensure Login Successful

End User submitting a request to delete their profile
    [Documentation]  GE-472. Check msisdn and email requirement.
    [Tags]  end-user

    springster.Login As User  end-user  ${RND_USER}  ${RND_PWD}
    springster.Delete Profile

Each form question can only be picked once.
    [Documentation]  Ensure that users are not able to select a pwd question multiple times.
    [Tags]  ready  end-user

    springster.Registration Questions  end-user
    #springster.registration questions  system-user

Create new system user profile
    [Documentation]  Register as a system user.
    [Tags]  ready  system-user
    
    springster.Generate User Name
    springster.Register As User  system-user  ${RND_USER}  ${RND_PWD}

Login as a new system user
    [Documentation]  Login as the system user created above.
    [Tags]  ready  system-user

    springster.Login As User  system-user  ${RND_USER}  ${RND_PWD}

Logout as system user
    [Documentation]
    [Tags]

Verify the fields shown on the system-user registration form.
    [Documentation]  Verify that the correct system user fields are shown.
    [Tags]  ready  system-user

    springster.Verify User Form Fields  system-user

System user password validation - length
    [Documentation]  Verify system user pwd length requirement.
    [Tags]  wip

    springster.Generate User Name
    springster.Register As User  system-user  ${RND_USER}  as
    springster.Password Length Error

Password confirmation doesn't match
    [Documentation]  Verify end user pwd requirement.
    [Tags]  wip1

    springster.Register As User  end-user  ${RND_USER}  ${EMPTY}
    springster.Password Match Error

OIDC consent form - end user
    [Documentation]
    [Tags]

OIDC consent form - system user
    [Documentation]
    [Tags]

Edit end user profile
    [Documentation]  
    [Tags]  

    springster.Login As User  end-user  ROBOT  ${RND_PWD}
    springster.Login As User  system-user  ${RND_USER}  ${RND_PWD} 

Edit end user lost password questions
    [Documentation]
    [Tags]

    springster.Login As User  end-user  ROBOT  ${RND_PWD}

Reset end user password with email address
    [Documentation]  
    [Tags]  

    # Add email address via API PUT request.
    girleffect_api.Change User State  3f08f30e-5dc4-11e8-99a6-0242ac11000a  user@example.com
    springster.Lost Password  end-user  ROBOT  ${RND_PWD}

    #girleffect_api.Change User State  ${END_USER_VALID}  user@example.com
    #springster.Lost Password  ${END_USER_VALID}

Reset system user password without email address via security questions
    [Documentation]  
    [Tags] 

    # Add email address via API PUT request.
    girleffect_api.Change User State  3f08f30e-5dc4-11e8-99a6-0242ac11000a  ${EMPTY}
    springster.Lost Password  system-user  ROBOT  ${RND_PWD}

    #girleffect_api.Change User State  ${END_USER_VALID}  user@example.com
    #springster.Lost Password  ${END_USER_VALID}

Create end user profile using email address which already exists
    [Documentation]  
    [Tags]  

    springster.Generate User Name
    springster.Register As User  ${END_USER_VALID}

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
