FROM localstack/localstack

ADD scripts/ ./scripts/
RUN chmod -R 777 ./scripts/
RUN pip install awscli-local
