*** Settings ***
Documentation  API tests
Resource  ../resources/API/girleffect_api.robot

*** Variables ***
${auth_host} =  authentication-service.qa-hub.ie.gehosting.org
${host} =  access-control-service.qa-hub.ie.gehosting.org
${API_KEY} =  qa_ThashaerieL2ahfa0ahy

*** Test Cases ***
Get access_token using password authentication
    [Tags]  API

    girleffect_api.Get Token

Get site roles for user
    [Tags]  API

    girleffect_api.Get Site Roles

Submit form with xxx details
    [Tags]

test restinstance
    [Documentation]  blah
    [Tags]  rest

    girleffect_api.rest get user id