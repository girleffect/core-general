# core-general

This repo will port to MkDocs: http://www.mkdocs.org/

Current docs/ still uses Sphinx.i

## Running the core components using `docker-compose`

To be able to run the core components using `docker-compose`, all the git repositories should be available on the same level as this repository and each contain a `Dockerfile`.

To quickly check if this is the case, run:
```
s -1 ../*/Dockerfile
```
which should result in the following output:
```
../core-access-control/Dockerfile
../core-authentication-service/Dockerfile
../core-management-layer/Dockerfile
../core-management-portal/Dockerfile
../core-user-data-store/Dockerfile
```

## Quick links to the Swagger Documentation for the Core Components

### Development branch

* [Access Control](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-access-control/develop/swagger/access_control.yml)
* [User Data Store](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-user-data-store/develop/swagger/user_data_store.yml)
* [Authentication Service](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-authentication-service/develop/swagger/authentication_service.yml)

### Master branch

* [Access Control](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-access-control/master/swagger/access_control.yml)
* [User Data Store](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-user-data-store/master/swagger/user_data_store.yml)
* [Authentication Service](http://petstore.swagger.io/?url=https://raw.githubusercontent.com/girleffect/core-authentication-service/master/swagger/authentication_service.yml)

## Other useful links

### Setting up HTTPS in Mesos Clusters

http://ways-of-working.readthedocs.io/en/latest/tech/https.html#https

