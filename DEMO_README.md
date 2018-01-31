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

Once everything is done, the wagtail demo app should be accessible on `http://172.18.0.4:8000/`

