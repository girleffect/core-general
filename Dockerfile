# Base GE image, based of off LTS Ubuntu 16.04. With Python 3.5.
FROM ubuntu:16.04

RUN apt-get update

# For now install the default python 3 that is available. 3.5.2
# TODO: apt cache should possibly be disabled to ensure no stale packages are used.
RUN apt-get install -y \
    python3 \
    python-virtualenv \
    vim
    #python-pip \
    #python-dev \
    #build-essential \
    #nginx \

RUN python3 --version

# NOTE: Depending on  project type more directories will be needed.
RUN mkdir -p /var/praekelt/app
WORKDIR /var/praekelt/app

RUN virtualenv  /var/praekelt/ve -p python3

# NOTE Projects need to have and copy their respective nginx/supervisor configs.
#eg:
#COPY config/supervisor/* /etc/supervisor/conf.d/
#COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
