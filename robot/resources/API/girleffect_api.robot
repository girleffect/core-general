*** Settings ***
Library  RequestsLibrary
Library  Collections

*** Variables ***
${AUTH_HOST} =  authentication-service.qa-hub.ie.gehosting.org
#${MGMT_HOST} =  access-control-service.qa-hub.ie.gehosting.org
${API_KEY} =  qa_ThashaerieL2ahfa0ahy

*** Keywords ***
Get Access Token
    RequestsLibrary.Create Session  hook  http://${AUTH_HOST}  verify=${True}
    ${body} =  Create Dictionary  grant_type=password  client_id=872786  client_secret=bc075e82af1b135bb1869db54f2d8ff34fa998c0e0a7988621b27058  username=jasonb  password=12QWas\!\@  scope=openid%20site%20roles%20email
    ${headers} =  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${resp} =  RequestsLibrary.Post Request  hook  /openid/token/  data=${body}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    ${accessToken} =  evaluate  $resp.json().get("access_token")
    #Log to Console  ${accessToken}
    Set Global Variable  ${accessToken}

Get ID Token
    RequestsLibrary.Create Session  hook  http://${AUTH_HOST}  verify=${True}
    ${body} =  Create Dictionary  grant_type=password  client_id=872786  client_secret=bc075e82af1b135bb1869db54f2d8ff34fa998c0e0a7988621b27058  username=jasonb  password=12QWas\!\@  scope=openid%20site%20roles%20email
    ${headers} =  Create Dictionary  Content-Type=application/x-www-form-urlencoded
    ${resp} =  RequestsLibrary.Post Request  hook  /openid/token/  data=${body}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    ${accessToken} =  evaluate  $resp.json().get("id_token")
    #Log to Console  ${accessToken}
    Set Global Variable  ${idToken}

Change User State
    [Documentation]  Set the user 'is_active' flag to true/false.
    [Arguments]  ${user_id}  ${state}  

    RequestsLibrary.Create Session  hook  http://${AUTH_HOST}  verify=${True}
    RequestsLibrary.Create Session  status  http://${AUTH_HOST}  verify=${True}

    # Do the PUT request:
    ${body} =  Create Dictionary  is_active=${state}
    ${headers} =  Create Dictionary  Accept=application/json  X-API-Key=${API_KEY}  Content-Type=application/json   
    ${resp} =  RequestsLibrary.Put Request  hook  /api/v1/users/${user_id}  data=${body}  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200

    # Check that the flag has been set correctly:
    ${headers} =  Create Dictionary  Accept=application/json  X-API-Key=${API_KEY}
    ${resp} =  RequestsLibrary.Get Request  status  /api/v1/users/${user_id}  headers=${headers}  
    Should be Equal  ${resp.json()["is_active"]}  ${state}

Get Site Roles
    RequestsLibrary.Create Session  hook  http://${host}  verify=${True}
    ${body} =  Create Dictionary  grant_type=password  client_id=872786  client_secret=bc075e82af1b135bb1869db54f2d8ff34fa998c0e0a7988621b27058  username=jasonb  password=12QWas\!\@  scope=openid%20site%20roles%20email
    ${headers} =  Create Dictionary  Accept=application/json  X-API-Key=${API_KEY 
    ${resp} =  RequestsLibrary.Get Request  hook  /api/v1/ops/tech_admin_resource_permissions  headers=${headers}
    Should Be Equal As Strings  ${resp.status_code}  200
    Log  ${resp.content}
    #Dictionary Should Contain Value  ${resp.json()}  ["permission_id"]