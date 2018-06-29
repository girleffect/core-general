&{RESET_USER_BLANK_PWD}
&{RESET_USER_INVALID_PWD}
&{RESET_USER_MIS_PWDS}
&{RESET_USER_INVALID_USERNAME}
&{RESET_USER_EXISTING_USERNAME}
&{RESET_USER_NO_EMAIL}
&{RESET_USER_LOCKOUT}


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

End user registration form credential checks
    [Template]  Registration Form Credential checks

    ${END_USER_INVALID_PASS}
    ${END_USER_BLANK_PASS}
    ${END_USER_MISMATCHED_PWDS}
    ${END_USER_EXISTING_USERNAME}
    ${END_USER_INVALID_USERNAME}
    ${END_USER_SAME_QUESTION}
