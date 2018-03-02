# Wagtail demo setup.

* _Setup docker network for static ips._
`$ make docker-network`

* _Run the docker compose spin up command._
`$ make run`

* _Get a list of the running docker containers._
`$ docker ps -a`

* _Look for a container similiar to this:_
```<id>        ge-auth:0.1         "scripts/waitFor.sh …"   27 minutes ago      Up 27 minutes       0.0.0.0:8000->8000/tcp             coregeneral_core-authentication-service_1```

* _Attach to the currently running container_
`$ docker exec -ti <id> /bin/bash`

* _Load the demo clients_
`$ python manage.py demo_content`

* _Create rsa keys for the clients._
`$ python manage.py creatersakey`

Once everything is done, the wagtail demo applications should be accessible on
* `http://wagtail-demo-1:8000/`
* `http://wagtail-demo-2:8000/`

It will redirect to the authentication service running on `http://core-authentication-service:8000/`

### User Credentials for Wagtail Demo:

* The superuser credentials for the Authentication Service is username `admin` and password `local`.

* The enduser credentials for the Authentication Service is username `enduser` and password `enduser`.

* The systemuser credentials for the Authentication Service is username `sysuser` and password `sysuser`. It
also includes 2FA, that requires Google Authenticator to be set up. The QR code to use with Google
Authenticator:

![alt text][logo]

[logo]:  https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=otpauth%3A%2F%2Ftotp%2FGirl%2520Effect%2520Demo%253A%2520sysuser%3Fsecret%3DVFFGMP7P36Q7TIZV3YZ65ZLHKQPAPXIM%26digits%3D6%26issuer%3DGirl%2BEffect%2BDemo "Girl Effect Demo QR code"
