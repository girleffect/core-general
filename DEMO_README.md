# Wagtail demo setup.

Setup docker network for static ips.
$ make docker-network

Run the docker compose spin up command.
$ make run 

Get a list of the running docker containers.
$ docker ps -a

Look for a container similiar to this:
<id>        ge-auth:0.1         "scripts/waitFor.sh …"   27 minutes ago      Up 27 minutes       0.0.0.0:8000->8000/tcp             coregeneral_core-authentication-service_1

$ docker exec -ti <id> /bin/bash

# Load the demo clients
$ python manage.py demo_content

# create an rsa key for the clients.
$ python manage.py creatersakey

