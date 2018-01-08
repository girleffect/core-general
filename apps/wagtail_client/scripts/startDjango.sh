#!/bin/bash

ADDRESS_VALUE=${ADDRESS:0.0.0.0:8000}

python manage.py migrate
python manage.py runserver $ADDRESS_VALUE
