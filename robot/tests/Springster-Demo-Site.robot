*** Settings ***
Documentation  This is a suite of tests for the Springster demo site.

Resource  ../data/InputData.robot  #stores relevant test variables.
Resource  ../resources/common.robot  #used for setup and teardown
Resource  ../resources/springster.robot  #stores lower level keywords used by test.
Resource  ../resources/api/girleffect_api.robot  #stores API level keywords.

#Suite Setup  Start Docker Container
Test Setup  Begin Web Test
Test Teardown  End Web Test
#Suite Teardown  Stop All Containers

*** Variables ***
#robot -d robot/results -v ENVIRONMENT:qa -v AUTHENTICATION_SERVICE_API_KEY:qa_ThashaerieL2ahfa0ahy -i ready robot/tests/Springster-Demo-Site.robot

*** Test Cases ***
# *** End User Checks ***
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
    [Documentation]  Logout from the profile edit page.
    [Tags]  ready  end-user

    springster.Login As User  ${END_USER_VALID}
    springster.Assert User Logged In
    springster.Logout From Profile Edit Page
    
End user registration credential validation
    [Documentation]  Test validation on end user registration form.
    [Tags]  ready  end-user
    [Template]  End User Registration Validation

    ${END_USER_REGISTERED}
    ${END_USER_PWD_SHORT}
    ${END_USER_PWD_BLANK}
    ${END_USER_PWD_MIS}

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

    springster.Submit First End User Form  ${END_USER_INVALID}
    springster.Assert Registration Errors

Password confirmation doesn't match
    [Documentation]  Password and password confirmation must match.
    [Tags]  ready  end-user

    springster.Submit First End User Form  ${END_USER_MIS_PASS}
    springster.Password Match Error  ${END_USER_MIS_PASS}

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
    [Tags]  ready  end-user  xxx
    [Template]  Reset Password Flow

    ${END_USER_STATIC}

Login with updated password (end user)
    [Documentation]  Login as the end user created above.
    [Tags]  ready  end-user
    [Template]  Login With Updated Password
    
    robotstatic  ${rnd_pwd}

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
    [Tags]  todo

    Page Should Contain  Ensure this value is less than or equal to 100.
    Page Should Contain  Error for 13 yr old validation

Exceed maximum login attempts
    [Documentation]  Form must show error after five failed login attempts.
    [Tags]  ready  end-user

    springster.Exceed Login Attempts  ${END_USER_RESET}

Attempt to login after user locked out.
    [Documentation]
    [Tags]  ready  end-user

    springster.Login As User  ${END_USER_RESET}
    springster.Ensure User Locked Out

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
    [Tags]  todo  end-user

Login to non-English site
    [Documentation]  Make sure the translated sites load.
    [Tags]  ready  end-user

    springster.Login As User  ${API_USER}
    springster.Load Localised Sites

Verify Home Link On Lockout Page
    [Documentation]  Home link should appear on lockout page.
    [Tags]  todo  end-user

Password reset link invalid/old/expired
    [Documentation]  Make sure invalid link is not accepted.
    [Tags]  todo  end-user

Back button on end user form should take user to first step.
    [Documentation]  Back button should take user to first step and keep fields filled in.
    [Tags]  end-user  todo

Supply end user email address and ensure that second registration step shows.
    [Documentation]  Second step of registration is optional. Only shows if user supplies email address.
    [Tags]  end-user  todo

Remove end user record
    [Documentation]  Remove the user record added in the first test.
    [Tags]  ready  end-user

    girleffect_api.Delete User  ${END_USER_VALID}

Each form question can only be picked once.
    [Documentation]  Ensure that users are not able to select a pwd question multiple times.
    [Tags]  ready  end-user

    springster.Registration Question Selection Validation  ${END_USER_VALID}
    girleffect_api.Delete User  ${END_USER_VALID}
    #springster.registration questions  system-user
    #TODO: Add check from profile edit as well.

Show preselected security questions on form.
    [Documentation]  GE-1086: User can specify which questions are shown in the form using url params.
    [Tags]  end-user  ready

    springster.Check Preselected Security Questions  ${END_USER_VALID}

Check security question default values
    [Documentation]  GE-1086: Ensure default values are in place if no question_id is specified.
    [Tags]  end-user  ready

    springster.Check Security Question Defaults  ${END_USER_VALID}

Check avatar field rejects .py file etc. jpgs. tiff. pngs.
User should not be able to login on disabled site
    [Documentation]  Set a site to inactive and make sure a user can't access the login screen.
    [Tags]  api

    girleffect_api.Change Site State  7  ${false}
    springster.Check Site State  https://ninyampinga-example.qa-hub.ie.gehosting.org/  false

Set site back to active and user should be able to see login page
    [Documentation]  User should be able to login to active site.
    [Tags]  api

    girleffect_api.Change Site State  7  ${true}
    springster.Check Site State  https://ninyampinga-example.qa-hub.ie.gehosting.org/  true

# *** System User Checks ***

Create a new system user profile
    [Documentation]  Register as a system user called 'robotsystem'.
    [Tags]  ready  system-user

    springster.Create New Profile  ${SYS_USER_VALID}
    springster.Check Registration Passed

Login as new system user
    [Documentation]  Login as the end user created above.
    [Tags]  ready  system-user

    springster.Login As User  ${SYS_USER_VALID}
    springster.Authorise Registration
    springster.Assert User Logged In

System user login credential validation
    [Documentation]  Test multiple login scenarios.
    [Tags]  ready  system-user
    [Template]  Login Form Credential Validation

    ${SYS_UNREGISTERED_USER}
    ${SYS_BLANK_USERNAME_USER}
    ${SYS_INVALID_PASSWORD_USER}

System user registration credential validation
    [Documentation]  Test registration form validation.
    [Tags]  ready  system-user
    [Template]  System User Registration Form Validation

    ${USERNAME_ALREADY_REGISTERED}
    ${PWD_BLANK}
    ${PWD_LESS_THAN_EIGHT_CHARS}
    ${PWD_NO_SPECIAL_CHARS}
    ${PWD_NO_UPPERCASE}
    ${PWD_NO_LOWERCASE}
    ${PWD_NO_NUMERICS}
    ${PWD_NOT_USERNAME}
    ${PWD_MISMATCH}

Reset system user pwd via lost password email
    [Documentation]  End-user with valid email address.
    [Tags]  ready  system-user
    [Template]  Reset Password Flow

    ${SYS_USER_STATIC}

Login with updated password (system user)
    [Documentation]  Login with the updated password created above.
    [Tags]  ready  system-user
    [Template]  Login With Updated Password
    
    systemstatic  ${rnd_pwd}

Remove system user record
    [Documentation]  Remove the user record added in the first test.
    [Tags]  ready  system-user

    girleffect_api.Delete User  ${SYS_USER_VALID}

# *** Invite User Flow ***

Send User Invite
    [Documentation]  Create and send user invite via GMP.
    [Tags]  wip  admin

    springster.Create Invite

Complete user registration via invite
    [Documentation]  Complete user registration via invite
    [Tags]  wip  admin

View user invite in GMP
    [Documentation]  Check valid/invalid invite in GMP
    [Tags]  wip  admin

 
Details on registration form must match user details entered by admin user.
    [Documentation]  Form details must match those entered by admin.
    [Tags]  wip  admin

Check that user is able to access site they are enabled for
    [Documentation]
    [Tags]  wip  admin

Ensure user is blocked from accessing site not enabled for
    [Documentation]
    [Tags]  wip  admin

Check user domain role
    [Documentation]
    [Tags]  wip  admin

Check user site role
    [Documentation]
    [Tags]  wip  admin