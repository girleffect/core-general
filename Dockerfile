# NOTE: To pull in a local image, it needs to be built out to your local repo
# first and then make use of FROM as usual.

# We use Python2.7 because robotframework requires it
# FROM praekeltfoundation/python-base:2.7-stretch
FROM joyzoursky/python-chromedriver:2.7-xvfb-selenium

WORKDIR /app

COPY requirements-robotframework.txt /app/
RUN pip install -r requirements-robotframework.txt

RUN apt-get update && apt-get -y dist-upgrade


COPY apps/robotframework/test_runner.sh /app/
COPY . /app/

ENV PATH="/app/:${PATH}"

CMD ["test_runner.sh"]
