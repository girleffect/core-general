*** Settings ***
Library  SeleniumLibrary
Library  String

*** Variables ***

${updatequestions.header} =  xpath://div[@id="title"]/h1
${updatequestions.question1} =  id:id_form-0-question
${updatequestions.answer1} =  id:id_form-0-answer
${updatequestions.question2} =  id:id_form-1-question
${updatequestions.answer2} =  id:id_form-1-answer
${updatequestions.update_btn} =  xpath://input[@value="Update"]
${updatequestions.back_btn} =  xpath://a[contains(text(), "Back")]

*** Keywords ***

Verify Edit Questions Page
    Wait Until Page Contains Element  ${updatequestions.header}
    Element Text Should Be  ${updatequestions.header}  UPDATE SECURITY QUESTIONS

    Element Should Be Visible  ${updatequestions.question1}
    Element Should Be Visible  ${updatequestions.answer1}
    Element Should Be Visible  ${updatequestions.question2}
    Element Should Be Visible  ${updatequestions.answer2}
    Element Should Be Visible  ${updatequestions.update_btn}
    Element Should Be Visible  ${updatequestions.back_btn}

Select Question One
    Select From List By Value  ${updatequestions.question1}  4

Fill In Answer Field One
    Input Text  ${updatequestions.answer1}  robotframework2 edit

Select Question Two
    Select From List By Value  ${updatequestions.question2}  2

Fill In Answer Field Two
    Input Text  ${updatequestions.answer2}  robotframework edit

Click Update
    Click Element  ${updatequestions.update_btn}
