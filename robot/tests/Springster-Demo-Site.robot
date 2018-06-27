*** Settings ***
Documentation  This is a suite of tests for the Springster demo site.

Resource  ../data/InputData.robot  #stores relevant test variables.
Resource  ../resources/common.robot  #used for setup and teardown
Resource  ../resources/springster.robot  #stores lower level keywords used by test.
Resource  ../resources/api/girleffect_api.robot  #stores API level keywords.

#Suite Setup  Start Docker Container
Test Setup  Begin Web Test
#Test Teardown  End Web Test
#Suite Teardown  Stop All Containers

*** Variables ***

*** Test Cases ***
Create a new end user profile
    [Documentation]  Register as an end user.
    [Tags]  ready  end-user

    springster.Create New Profile  ${END_USER_VALID}
    springster.Check Registration Passed

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

Logout from user's edit profile page
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

Site must not allow de-activated user to login. 
    [Documentation]  De-activate an end-user and ensure they are blocked from accessing the site.
    [Tags]  ready  end-user

    girleffect_api.Change User State  ${API_USER}  ${false}
    springster.Login As User  ${API_USER}
    springster.Ensure Login Blocked

Site must allow re-activated user to login.
    [Documentation]  Re-activate a previously blocked user and ensure they can login.
    [Tags]  ready  end-user

    girleffect_api.Change User State  ${API_USER}  ${true}
    springster.Login As User  ${API_USER}
    #springster.Authorise Registration
    springster.Assert User Logged In

Check that site displays errors if empty fields submitted on registration.
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

Reset end user password and enter invalid password length.
    [Documentation]  Ensure that the validation rules applied on registration form are used on the reset form.
    [Tags]  ready  end-user

    #springster.Reset Password Via Email  ${API_USER}
    springster.Reset Password Submit Answers  ${API_USER}
    springster.Reset Password Submit Invalid Password  ${END_USER_INVALID_PASS}
    springster.Password Length Error  ${END_USER_INVALID_PASS}

Reset end user pwd via security questions and answer security questions incorrectly.
    [Documentation]  Check that form throws appropriate error if the security question answers are incorrect. Test below checks this anyway.
    [Tags]  deprecated  end-user

    springster.Reset Password Wrong Answers  ${END_USER_WRONG_ANSWERS}

Reset end user pwd via security questions - lockout
    [Documentation]  User must be locked out if the user enters incorrect security question answers during the reset flow.
    [Tags]  ready  end-user

    springster.Reset Password Lockout  ${END_USER_WRONG_ANSWERS}

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
    [Documentation]  GE-472. Check that user account without email/msisdn can be deleted.
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
    springster.Goto Edit User Profile Page
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
    springster.Goto Edit User Profile Page
    springster.Update User Password
    springster.Enter Old Password  ${END_USER_RESET}
    springster.Enter New Password  ${END_USER_RESET}
    springster.Assert Old Password Error

Update end user password via profile page - enter invalid password length.
    [Documentation]  System must throw error if user enters invalid password length.
    [Tags]  ready  end-user

    springster.Login As User  ${END_USER_RESTORE}
    springster.Goto Edit User Profile Page
    springster.Update User Password
    springster.Enter Old Password  ${END_USER_RESTORE}
    springster.Enter New Password  ${END_USER_INVALID_PASS}
    springster.Password Length Error  ${END_USER_INVALID_PASS}

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

Password validation on password update page.
    [Documentation]  Ensure that the validation rules applied on registration form are used on the update form.
    [Tags]  wip  end-user

Login to non-English site
    [Documentation]  Make sure the translated sites load.
    [Tags]  ready  end-user

    springster.Login As User  ${API_USER}
    springster.Load Localised Sites

Verify Home Link On Lockout Page
    [Documentation]  Home link should appear on lockout page.
    [Tags]  wip  end-user

Password reset link invalid/old/expired
    [Documentation]  Make sure the translated sites load.
    [Tags]  wip  end-user

Remove end user record
    [Documentation]  Remove the user record added in the first test.
    [Tags]  ready  end-user

    girleffect_api.Delete User  ${END_USER_VALID}

## Do some system-user checks here:

Create a new system user profile
    [Documentation]  Register as a system user.
    [Tags]  ready  system-user

    springster.Create New Profile  ${SYS_USER_VALID}
    springster.Check Registration Passed

Login as new system user
    [Documentation]  Login as the end user created above.
    [Tags]  ready  system-user

    springster.Login As User  ${SYS_USER_VALID}
    springster.Authorise Registration
    springster.Assert User Logged In

Remove system user record
    [Documentation]  Remove the user record added in the first test.
    [Tags]  ready  system-user

    girleffect_api.Delete User  ${SYS_USER_VALID}

System user password validation
    [Template]  System user password checks

    username  password  registered
    valid       blank   not registered
    blank       too short     not registered
    blank       blank       not registered
    valid       valid       already registered
    valid       no uppercase etc.   not registered