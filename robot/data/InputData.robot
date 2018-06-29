*** Variables ***

${ENVIRONMENT} =  Get Environment Variable ENVIRONMENT docker
${BROWSER} =  chrome
&{URL}  local=http://localhost:8000  qa=http://springster-example.qa-hub.ie.gehosting.org/  docker=http://wagtail-demo-1-site-1:8000/
&{AUTH_SERVICE_URL}  qa=https://authentication-service.qa-hub.ie.gehosting.org
&{GMP_URL}  local=http://localhost:8000  qa=http://management-portal.qa-hub.ie.gehosting.org/#/login
&{API_USER}  id=568a2114-6a3b-11e8-aa86-0242ac11000f  username=robotapiuser  pwd=SDF45!@  pwd_conf=SDF45!@  first_answer=blue  second_answer=blue
&{END_USER_VALID}  type=end-user  username=robotframework  pwd=SDF45!@  pwd_conf=SDF45!@  email=jasonbarr.qa@gmail.com  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_INVALID}  type=end-user  username=${EMPTY}  pwd=password  pwd_conf=password  email=jasonbarr.qa@gmail.com  age=${EMPTY}  gender=male  first_question=1  first_answer=black  second_question=2  second_answer=black
&{END_USER_RESET}  username=klikl  pwd=reset  pwd_conf=reset  email=jasonbarr.qa@gmail.com  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_RESTORE}  username=klikl  pwd=restore  pwd_conf=restore  email=jasonbarr.qa@gmail.com  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2
&{END_USER_INVALID_PASS}  type=end-user  username=qwerty  pwd=as  pwd_conf=as  email=jasonbarr.qa@gmail.com  age=18  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2  error=Password not long enough.
&{END_USER_BLANK_PASS}  type=end-user  username=qwerty  pwd=${EMPTY}  pwd_conf=${EMPTY}  email=unknown@ge.com  age=18  gender=male  first_question=1  first_answer=black  second_question=2  second_answer=blue  error=This field is required.
&{END_USER_MIS_PASS}  type=end-user  username=robotapiuser  pwd=zetas  pwd_conf=orion  age=21  gender=male  first_question=1  first_answer=blue  second_question=2  second_answer=blue  error=The two password fields didn't match.
&{END_USER_WRONG_ANSWERS}  username=robotanswers  first_answer=blue  second_answer=black

&{SYS_USER_VALID}  type=system-user  username=robotsystem  pwd=sDf45Y7!@  pwd_conf=sDf45Y7!@  fname=Robot  lname=Framework  email=jasonbarr.qa+sys@gmail.com  age=21  gender=male  first_question=1  first_answer=1  second_question=2  second_answer=2  msisdn=0213456789  country=ZA
&{SYS_UNREGISTERED_USER}  type=system-user  username=robotnoreg  pwd=sDf45Y7!@  error=Please enter a correct username and password. Note that both fields may be case-sensitive.
&{SYS_BLANK_USERNAME_USER}  type=system-user  username=${EMPTY}  pwd=sDf45Y7!@  pwd_conf=sDf45Y7!@  error=This field is required.
&{SYS_INVALID_PASSWORD_USER}  type=system-user  username=robotsystem  pwd=wrongpass  error=Please enter a correct username and password. Note that both fields may be case-sensitive.