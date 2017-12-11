# NOTE: To pull in a local image, it needs to be built out to your local repo
# first and then make use of FROM as usual.

# Base GE image, based off of Ubuntu 17.10. With Python 3.6.3.
FROM ubuntu:17.10

# NOTE: Projects making use of this base will need to install its own
# dependencies.
# Overlapping dependencies will be added here as Girl Effect matures.
# eg: nginx, supervisor, etc.
RUN apt-get update && apt-get install -y python3 python3-pip

# Ubuntu 17.10 comes with no default python or pip installed, so we do this for
# convenience.
RUN ln -s /usr/bin/pip3 /usr/bin/pip && ln -s /usr/bin/python3 /usr/bin/python

# NOTE Projects need to have and copy their respective nginx/supervisor configs.
# eg:
# COPY config/supervisor/* /etc/supervisor/conf.d/
# COPY config/nginx/nginx.conf /etc/nginx/nginx.conf

# Set app directory to working directory.
ONBUILD WORKDIR /var/app
