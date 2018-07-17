FROM python:3.6

WORKDIR /app

EXPOSE 25

CMD python3 -u -m smtpd -n -c DebuggingServer ${HOSTNAME}:25
