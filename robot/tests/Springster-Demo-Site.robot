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
&{API_USER}  id=568a2114-6a3b-11e8-aa86-0242ac11000f  username=robotapiuser  pwd=SDF45!@  pwd_conf=SDF45!@  first_answer=blue  second_answer=blue
&{END_USER_VALID}  type=end-user  username=robotframework  pwd=SDF45!@  pwd_conf=SDF45!@  email=jasonbarr.qa@gmail.com  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_INVALID}  type=end-user  username=${EMPTY}  pwd=password  pwd_conf=password  email=jasonbarr.qa@gmail.com  age=${EMPTY}  gender=male  first_question=1  first_answer=black  second_question=2  second_answer=black
&{END_USER_RESET}  username=klikl  pwd=reset  pwd_conf=reset  email=jasonbarr.qa@gmail.com  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_RESTORE}  username=klikl  pwd=restore  pwd_conf=restore  email=jasonbarr.qa@gmail.com  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_INVALID_PASS}  type=end-user  username=qwerty  pwd=as  pwd_conf=as  email=jasonbarr.qa@gmail.com  age=18  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_BLANK_PASS}  type=end-user  username=qwerty  pwd=${EMPTY}  pwd_conf=${EMPTY}  email=unknown@ge.com  age=18  gender=male  first_question=1  first_answer=black  second_question=2  second_answer=blue
&{END_USER_MIS_PASS}  type=end-user  username=robotapiuser  pwd=zetas  pwd_conf=orion  age=21  gender=male  first_question=1  first_answer=blue  second_question=2  second_answer=blue
&{END_USER_WRONG_ANSWERS}  username=robotapiuser  first_answer=blue  second_answer=black

*** Test Cases ***
Create new end user profile
    [Documentation]  Register as an end user.
    [Tags]  ready  end-user

    springster.Create New Profile  ${END_USER_VALID}

Login as a new end-user
    [Documentation]  Login as the end user created above.
    [Tags]  ready  end-user

    springster.Login As User  ${END_USER_VALID}
    springster.Authorise Registration
    springster.Assert User Logged In

Logout as end user
    [Documentation]
    [Tags]  ready  end-user

    springster.Login As User  ${END_USER_VALID}
    springster.Assert User Logged In
    springster.Logout

    # If logout is successful the user will be taken to the Springster Demo Example Home Page.
    springster.Assert Landing Page Header

Logout from edit profile page 
    [Documentation]
    [Tags]

Create end user profile using username which already exists
    [Documentation]  Register with existing username.
    [Tags]  ready  end-user

    springster.Assert Existing User Error  ${END_USER_VALID}  username

End user password validation - length
    [Documentation]  Verify end user pwd length requirement. Submit two char password.
    [Tags]  ready  end-user

    springster.Generate User Name
    springster.Create New Profile  ${END_USER_INVALID_PASS}
    springster.Password Length Error  ${END_USER_INVALID_PASS}

End user password validation - blank
    [Documentation]  Form must show appropriate error if password field is not entered.
    [Tags]  ready  end-user

    springster.Generate User Name
    springster.Create New Profile  ${END_USER_BLANK_PASS}
    springster.Password Blank Error

Verify the fields shown on the end-user registration form.
    [Documentation]  The end user form should have different visible fields to the system user form.
    [Tags]  ready  end-user

    springster.Verify User Form Fields  end-user

De-activate end user
    [Documentation]  De-activate an end-user and ensure they are blocked from accessing the site.
    [Tags]  ready  end-user

    girleffect_api.Change User State  ${API_USER}  ${false}
    springster.Login As User  ${API_USER}
    springster.Ensure Login Blocked

Re-activate end user
    [Documentation]  Re-activate a previously blocked user and ensure they can login.
    [Tags]  ready  end-user

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

Password confirmation doesn't match
    [Documentation]  Password and password confirmation must match.
    [Tags]  ready  end-user

    springster.Create New Profile  ${END_USER_MIS_PASS}
    springster.Password Match Error

Reset end user pwd via security questions
    [Documentation]  Reset password by answering security questions. End-user with no email address.
    [Tags]  ready  end-user

    springster.Reset Password Via Questions  ${API_USER}
    springster.Verify Django Success Page
    springster.Login As User  ${API_USER}
    springster.Assert User Logged In

Reset end user pwd via security questions and enter mismatched passwords.
    [Documentation]  Check that form throws appropriate error if passwords don't match.
    [Tags]  ready  end-user

    springster.Reset Password Via Questions  ${END_USER_MIS_PASS}
    springster.Verify Password Mismatch

Reset end user pwd via security questions and answer security questions incorrectly.
    [Documentation]  Check that form throws appropriate error if the security question answers are incorrect.
    [Tags]  ready  end-user

    springster.Reset Password Wrong Answers  ${END_USER_WRONG_ANSWERS}

Reset end user pwd via security questions - lockout
    [Documentation]  User must be locked out if the user enters incorrect credentials during the reset flow.
    [Tags]  ready  end-user

    springster.Reset Password Lockout  ${END_USER_MIS_PASS}

Reset end user pwd via lost password email
    [Documentation]  End-user with valid email address.
    [Tags]  ready  end-user

    springster.Reset Password Via Email  ${END_USER_VALID}
    springster.Check Password Reset Email
    springster.Open Password Update Page
    springster.Complete Password Reset  ${END_USER_VALID}

End User submitting a request to delete their profile - valid email
    [Documentation]  GE-472. User can only request a profile removal if they have an msisdn or email listed for their account.
    [Tags]  ready  end-user

    springster.Login As User  ${END_USER_RESTORE}
    springster.Delete User Profile  ${END_USER_RESTORE}

End User submitting a request to delete their profile - no email or msisdn
    [Documentation]  GE-472. Check msisdn and email requirement. User must have valid values for both.
    [Tags]  ready  end-user

    springster.Login As User  ${API_USER}
    springster.Delete User Profile  ${API_USER}

End User submitting a request to delete their profile - valid msisdn
    [Documentation]  GE-472. Check msisdn and email requirement.
    [Tags]  ready  end-user

    girleffect_api.Get User ID  ${END_USER_VALID}
    girleffect_api.Put MSISDN  ${END_USER_VALID}  0712345678
    springster.Login As User  ${END_USER_VALID}
    springster.Delete User Profile  ${END_USER_VALID}
    girleffect_api.Put MSISDN  ${END_USER_VALID}  ${EMPTY}

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

End user age validation
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
    [Documentation]  Form must show error after five failed login attempts.
    [Tags]  ready  end-user

    springster.Exceed Login Attempts  ${END_USER_RESET}

Attempt to login after user locked out.
    [Documentation]
    [Tags]  ready  end-user

    springster.Login As User  ${END_USER_RESET}
    springster.Ensure User Locked Out

OIDC consent form - end user
    [Documentation]
    [Tags]

Reset password for username which does not exist.
    [Documentation]  Form will still show message saying that the password reset mail has been sent.
    [Tags]  ready  end-user

    springster.Reset Password Invalid Username  ${END_USER_BLANK_PASS}
    springster.Show Reset Sent Message

Reset password for email address which does not exist.
    [Documentation]  Form will still show message saying that the password reset mail has been sent.
    [Tags]  ready  end-user

    springster.Reset Password Invalid Username  ${END_USER_BLANK_PASS}
    springster.Show Reset Sent Message

Password validation on reset pages. Must enforce rules for end/system users.
    [Documentation]  Ensure that the validation rules applied on registration form are used on the reset form.
    [Tags]  xxx  end-user

Password validation on password update page. Must enforce rules for end/system users.
    [Documentation]  Ensure that the validation rules applied on registration form are used on the reset form.
    [Tags]  xxx  end-user

  
Verify Home Link On Lockout Page

Remove end user record
    [Documentation]  Remove the user record added in the first test. 
    [Tags]  ready  end-user

    girleffect_api.Delete User  ${END_USER_VALID}