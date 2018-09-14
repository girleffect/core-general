# core-general

## Running the core components using `docker-compose`

To be able to run the core components using `docker-compose`, all the git repositories should be available on the same level as this repository and each contain a `Dockerfile`.

To quickly check if this is the case, run the following from the directory containing this README:
```
ls -1 ../*/Dockerfile
```
which should result in the following output:
```
../core-access-control/Dockerfile
../core-authentication-service/Dockerfile
../core-management-layer/Dockerfile
../core-management-portal/Dockerfile
../core-user-data-store/Dockerfile
```

For development run `make run-with-dev-portal` as a shortcut to start `docker-compose` with the `core-management-portal` in a dev build.
You can use `make run` as a shortcut to start `docker-compose` production based environment for the `core-management-portal`.
Look at [DEMO_README.md](DEMO_README.md) for further setup instructions.

## Quick links to the Swagger Documentation for the Core Components

### Development branch

Internal APIs
* [Access Control](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-access-control/develop/swagger/access_control.yml)
* [User Data Store](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-user-data-store/develop/swagger/user_data_store.yml)
* [Authentication Service](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-authentication-service/develop/swagger/authentication_service.yml)

External APIs
* [Management Layer](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-management-layer/develop/swagger/management_layer.yml)

### Master branch

Internal APIs
* [Access Control](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-access-control/master/swagger/access_control.yml)
* [User Data Store](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-user-data-store/master/swagger/user_data_store.yml)
* [Authentication Service](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-authentication-service/master/swagger/authentication_service.yml)


External APIs
* [Management Layer](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-management-layer/master/swagger/management_layer.yml)

## Other useful links

### Continuous Integration

* Build information: https://travis-ci.org/girleffect
* Test coverage information: https://coveralls.io/github/girleffect

### Setting up HTTPS in Mesos Clusters

http://ways-of-working.readthedocs.io/en/latest/tech/https.html#https

### Creating sites on access-control via curl:
curl 'http://access-control-service.qa-hub.ie.gehosting.org/api/v1/sites' \
-H 'content-type: application/json' -H 'x-api-key: <API-KEY-ENV-VAR>' \
--data '{"domain_id":<integer>,"client_id":<django_client_id>, "name":"site-name"}'

### Spinnaker LoadBalancer-related tags

For certificate generation:
```
MARATHON_ACME_0_DOMAIN name.of.domain
```

For redirecting to HTTPS on LB:
```
HAPROXY_0_REDIRECT_TO_HTTPS true
```

To expose services internally without a loadbalancer, edit the deploy stage pipeline job:
```
  "serviceEndpoints": [
    {
      "exposeToHost": false,
      "labels": {
        "VIP_0": "/access-control:8080"
      },
      "loadBalanced": true,
      "name": "web",
      "networkType": "BRIDGE",
      "port": 80,
      "protocol": "tcp"
    }
  ],
```
This will make the service available internally as:
```
access-control.marathon.l4lb.thisdcos.directory:8080
```

