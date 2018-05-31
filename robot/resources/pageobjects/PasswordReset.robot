*** Settings ***
Library  SeleniumLibrary

*** Variables ***
${passwordreset.header}  id:header
${passwordreset.back_btn}  xpath://a[@href="http://${URL.${ENVIRONMENT}}/oidc/callback/"]
${passwordreset.input}  name:email
${passwordreset.input}  xpath://*//input[@value="Submit"]

*** Keywords ***
