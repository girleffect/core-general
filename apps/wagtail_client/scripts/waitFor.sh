#!/bin/bash

until nc -z ${DB_HOST:=db} ${DB_PORT:=5432} > /dev/null; do
    echo "Postgres not available yet."
    sleep 2
done

exec "$@"
