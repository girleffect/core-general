# core-general

This repo will port to MkDocs: http://www.mkdocs.org/

Current docs/ still uses Sphinx.

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

You can use `make run` as a shortcut to start `docker-compose`.

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

