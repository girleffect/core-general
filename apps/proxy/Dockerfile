FROM python:3.6

WORKDIR /app

COPY ./proxy.pac ./app/proxy.pac

EXPOSE 8000

ENTRYPOINT ["python3"]

CMD ["-m", "http.server"]
