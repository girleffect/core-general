*** Settings ***
Documentation  API tests
Resource  ../resources/API/girleffect_api.robot

*** Variables ***
${AUTHENTICATION_SERVICE_API_KEY} =  Get Environment Variable AUTHENTICATION_SERVICE_API_KEY

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

    #girleffect_api.rest get token  
    girleffect_api.rest get user id

test
    [Tags]  test

    girleffect_api.test
