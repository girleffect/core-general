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
&{API_USER}  id=568a2114-6a3b-11e8-aa86-0242ac11000f  username=robotapiuser  pwd=SDF45!@
&{END_USER_VALID}  type=end-user  username=robotframework  pwd=SDF45!@  email=jasonbarr.qa@gmail.com  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_INVALID}  type=end-user  username=${EMPTY}  pwd=password  email=jasonbarr.qa@gmail.com  age=${EMPTY}  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_RESET}  username=klikl  pwd=reset  email=jasonbarr.qa@gmail.com  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_RESTORE}  username=klikl  pwd=restore  email=jasonbarr.qa@gmail.com  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_NOPASS}  type=end-user  username=qwerty  pwd=${EMPTY}  email=jasonbarr.qa@gmail.com  age=${EMPTY}  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_INVALID_PASS}  type=end-user  username=qwerty  pwd=as  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2

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

Create end user profile using username which already exists
    [Documentation]  Register with existing username.
    [Tags]  ready  end-user

    springster.Assert Existing User Error  ${END_USER_VALID}  username

End user password validation - length
    [Documentation]  Verify end user pwd length requirement.
    [Tags]  ready  end-user

    springster.Generate User Name
    springster.Create New Profile  ${END_USER_INVALID_PASS}
    springster.Password Length Error  ${END_USER_INVALID_PASS}

End user password validation - blank
    [Documentation]  Verify end user pwd requirement.
    [Tags]  ready  end-user

    springster.Generate User Name
    springster.Create New Profile  ${END_USER_NOPASS}
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
    #springster.Authorise Registration
    springster.Assert User Logged In

End user registration with missing fields
    [Documentation]  WHEN a user does not complete the mandatory fields THEN the system should display an error message in red text
    [Tags]  ready  end-user

    springster.Generate User Name
    springster.Create New Profile  ${END_USER_INVALID}
    springster.Assert Registration Errors

Reset end user pwd via security questions
    [Documentation]  End-user with no email address.
    [Tags]  wip  end-user

    springster.Reset Password Via Questions  ${END_USER_VALID}
    springster.Check Password Reset Email
    springster.Open Password Update Page
    springster.Complete Password Reset  ${END_USER_VALID}

Reset end user pwd via security questions
    [Documentation]  Get questions wrong, get locked out.
    [Tags]  wip  end-user

    springster.Reset Password Via Questions  ${END_USER_VALID}
    springster.Check Password Reset Email
    springster.Open Password Update Page
    springster.Complete Password Reset  ${END_USER_VALID}

Reset end user pwd via lost password email
    [Documentation]  End-user with no email address.
    [Tags]  ready  end-user

    springster.Reset Password Via Email  ${END_USER_VALID}
    springster.Check Password Reset Email
    springster.Open Password Update Page
    springster.Complete Password Reset  ${END_USER_VALID}

End User submitting a request to delete their profile - with email
    [Documentation]  GE-472. Check msisdn and email requirement.
    [Tags]  ready  end-user

    springster.Login As User  ${END_USER_RESTORE}
    springster.Delete User Profile  ${END_USER_RESTORE}

End User submitting a request to delete their profile - no email
    [Documentation]  GE-472. Check msisdn and email requirement.
    [Tags]  ready  end-user

    springster.Login As User  ${API_USER}
    springster.Delete User Profile  ${API_USER}

Edit end user profile
    [Documentation]  
    [Tags]  ready  end-user
    
    springster.Login As User  ${END_USER_RESTORE}
    springster.Edit User Profile  female  25
    springster.Reset Edited Fields  male  16

Edit end user lost password questions
    [Documentation]
    [Tags]  ready  end-user

    springster.Login As User  ${END_USER_RESTORE}
    springster.Update Security Questions

Update end user password via profile page
    [Documentation]
    [Tags]  ready  end-user

    springster.Login As User  ${END_USER_RESTORE}
    springster.Goto Edit Profile Page
    springster.Update User Password
    springster.Enter Old Password  ${END_USER_RESTORE}
    springster.Enter New Password  ${END_USER_RESET} 
    springster.Verify Password Reset Message

    # Reset to original password:
    springster.Update User Password
    springster.Enter Old Password  ${END_USER_RESET}
    springster.Enter New Password  ${END_USER_RESTORE} 

Update end user password via profile page - enter incorrect old password.
    [Documentation]  System must throw error if user does not enter the correct old password.
    [Tags]  ready  end-user

    springster.Login As User  ${END_USER_RESTORE}
    springster.Goto Edit Profile Page
    springster.Update User Password
    springster.Enter Old Password  ${END_USER_RESET}
    springster.Enter New Password  ${END_USER_RESET}
    springster.Assert Old Password Error

Age validation
    [Documentation]  
    [Tags]  wip

    Page Should Contain  Ensure this value is less than or equal to 100.
    Page Should Contain  Error for 13 yr old validation

Each form question can only be picked once.
    [Documentation]  Ensure that users are not able to select a pwd question multiple times.
    [Tags]  ready  end-user

    springster.Registration Questions  ${END_USER_VALID}
    #springster.registration questions  system-user
    #TODO: Add check from profile edit as well.

Exceed maximum login attempts
    [Documentation]
    [Tags]  ready  end-user

    springster.Exceed Login Attempts  ${END_USER_RESET}

Password confirmation doesn't match
    [Documentation]  Verify end user pwd requirement.
    [Tags]  wip1

    springster.Register As User  ${END_USER_INVALID}
    springster.Password Match Error

Remove end user record
    [Documentation]  
    [Tags]  del  end-user

    girleffect_api.Delete User  ${END_USER_VALID}

Create new system user profile
    [Documentation]  Register as a system user.
    [Tags]  ready  system-user

    springster.Create New Profile  ${SYS_USER_VALID}

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

Create system user profile using email address which already exists
    [Documentation]  Register with existing email address. Only applicable to system-users (for now.) 
    [Tags]  ready  system-user

    springster.Assert Existing User Error  ${SYS_USER_VALID}  email

Create system user profile using username which already exists
    [Documentation]  Register with existing username. Only applicable to system-users (for now.) 
    [Tags]  wip  system-user

    springster.Assert Existing User Error  ${SYS_USER_VALID}  username

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
    girleffect_api.Change User State  ${SYS_USER_VALID}  user@example.com
    springster.Lost Password  ${SYS_USER_VALID}

Reset system user password questions
    [Documentation]  
    [Tags] 

    # Add email address via API PUT request.
    girleffect_api.Change User State  ${SYS_USER_VALID}  ${EMPTY}
    springster.Lost Password  ${SYS_USER_VALID}

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

Logout from edit profile page 
