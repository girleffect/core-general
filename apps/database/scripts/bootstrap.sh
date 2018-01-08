#!/bin/bash

docker-entrypoint.sh postgres

DB_NAMES=${DBS:=authservice accesscontrol userdatastore $WAGTAILDBS}

until psql --username=postgres -c '\q'; do
    echo "Postgres is unavailable - sleeping"
    sleep 1
done

for name in $DB_NAMES;
do
    createdb $name --encoding=UTF8 --username=postgres
done
