FROM praekeltfoundation/python-base:3.6

RUN apt-get update && apt-get install -y netcat

WORKDIR /app/

COPY ./requirements /app/requirements

RUN pip install -r requirements/requirements.txt

COPY . /app/

EXPOSE 8000

ENTRYPOINT ["scripts/waitFor.sh"]

CMD ["scripts/startDjango.sh"]
