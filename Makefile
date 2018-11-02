VENV=./ve
PYTHON=$(VENV)/bin/python
PIP=$(VENV)/bin/pip
DOCKER-VERSION=1.0

# Colours.
CLEAR=\033[0m
RED=\033[0;31m
GREEN=\033[0;32m
CYAN=\033[0;36m

.SILENT: docs-build

help:
	@echo "usage: make <target>"
	@echo "    $(CYAN)build-virtualenv$(CLEAR): Creates virtualenv directory, 've/', in project root."
	@echo "    $(CYAN)clean-virtualenv$(CLEAR): Deletes 've/' directory in project root."
	@echo "    $(CYAN)docs-build$(CLEAR): Build documents and place html output in docs root."
	@echo "    $(CYAN)build-run-core$(CLEAR): Build images for and run the core components using docker-compose."
	@echo "    $(CYAN)run-core$(CLEAR): Run the core components using docker-compose."
	@echo "    $(CYAN)build-run-core-with-aws$(CLEAR): Build images for and run the core components alongside aws localstack using docker-compose."
	@echo "    $(CYAN)run-core-with-aws$(CLEAR): Run the core components alongside aws localstack using docker-compose."
	@echo "    $(CYAN)build-run-with-apps$(CLEAR): Build images for run the core components, alongside some non core apps, using docker-compose."
	@echo "    $(CYAN)run-with-apps$(CLEAR): Run the core components, alongside some non core apps, using docker-compose."
	@echo "    $(CYAN)docker-build-image$(CLEAR): Build out the Girl Effect base image to the local docker repo."
	@echo "    $(CYAN)docker-remove-image$(CLEAR): Remove the Girl Effect base image from the local docker repo. NOTE: Only the Girl Effect image gets removed, not the one/s it is based off"
	@echo "    $(CYAN)list-services$(CLEAR): List the services defined in the docker-compose.yml file""

$(VENV):
	@echo "$(CYAN)Initialise base ve...$(CLEAR)"
	virtualenv $(VENV) -p python2.7
	@echo "$(GREEN)DONE$(CLEAR)"

# Creates the virtual environment.
build-virtualenv: $(VENV)
	@echo "$(CYAN)Building virtualenv...$(CLEAR)"
	$(PIP) install docker-compose
	@echo "$(GREEN)DONE$(CLEAR)"

# Deletes the virtual environment.
clean-virtualenv:
	@echo "$(CYAN)Clearing virtualenv...$(CLEAR)"
	rm -rf $(VENV)
	@echo "$(GREEN)DONE$(CLEAR)"

# Build sphinx docs, then move them to docs/ root for GitHub Pages usage.
docs-build:  $(VENV)
	@echo "$(CYAN)Installing Sphinx requirements...$(CLEAR)"
	$(PIP) install sphinx sphinx-autobuild sphinx_rtd_theme
	@echo "$(GREEN)DONE$(CLEAR)"
	@echo "$(CYAN)Backing up docs/ directory content...$(CLEAR)"
	tar -cvf backup.tar docs/source docs/Makefile
	@echo "$(GREEN)DONE$(CLEAR)"
	@echo "$(CYAN)Clearing out docs/ directory content...$(CLEAR)"
	rm -rf docs/
	@echo "$(GREEN)DONE$(CLEAR)"
	@echo "$(CYAN)Restoring base docs/ directory content...$(CLEAR)"
	tar -xvf backup.tar
	@echo "$(GREEN)DONE$(CLEAR)"
	# Remove the tar file.
	rm backup.tar
	# Actually make html from index.rst
	@echo "$(CYAN)Running sphinx command...$(CLEAR)"
	$(MAKE) -C docs/ clean html SPHINXBUILD=../$(VENV)/bin/sphinx-build
	@echo "$(GREEN)DONE$(CLEAR)"
	@echo "$(CYAN)Moving build files to docs/ root...$(CLEAR)"
	cp -r docs/build/html/. docs/
	rm -rf docs/build/
	@echo "$(GREEN)DONE$(CLEAR)"

docker-network:
	docker network create --subnet=172.18.0.0/24 --gateway=172.18.0.1 oidcnetwork

build-run-core: build-virtualenv
	@echo "$(CYAN)Building and running docker-compose for core services...$(CLEAR)"
	@sudo $(VENV)/bin/docker-compose -f compose_files/docker-compose.yml -f compose_files/docker-compose.core-management-portal.yml up --build

run-core: build-virtualenv
	@echo "$(CYAN)Running docker-compose for core services....$(CLEAR)"
	@sudo $(VENV)/bin/docker-compose -f compose_files/docker-compose.yml -f compose_files/docker-compose.core-management-portal.yml up

build-run-core-with-aws: build-virtualenv
	@echo "$(CYAN)Building and running docker-compose for core services alongside aws localstack...$(CLEAR)"
	@sudo $(VENV)/bin/docker-compose -f compose_files/docker-compose.yml -f compose_files/docker-compose.core-management-portal.yml -f compose_files/docker-compose.localstack.yml up --build

run-core-with-aws: build-virtualenv
	@echo "$(CYAN)Building and running docker-compose for core services alongside aws localstack...$(CLEAR)"
	@sudo $(VENV)/bin/docker-compose -f compose_files/docker-compose.yml -f compose_files/docker-compose.core-management-portal.yml -f compose_files/docker-compose.localstack.yml up

build-run-with-apps: build-virtualenv
	@echo "$(CYAN)Building and running docker-compose for core services as well as other apps...$(CLEAR)"
	@sudo $(VENV)/bin/docker-compose -f compose_files/docker-compose.yml -f compose_files/docker-compose.core-management-portal.yml -f compose_files/docker-compose.apps.yml up --build

run-with-apps: build-virtualenv
	@echo "$(CYAN)Running docker-compose for core services as well as other apps...$(CLEAR)"
	@sudo $(VENV)/bin/docker-compose -f compose_files/docker-compose.yml -f compose_files/docker-compose.core-management-portal.yml -f compose_files/docker-compose.apps.yml up

docker-build-image:
	@echo "$(CYAN)Building local image (version:$(DOCKER-VERSION))...$(CLEAR)"
	docker build -t robotframework:$(DOCKER-VERSION) .
	@echo "$(GREEN)DONE$(CLEAR)"

docker-remove-image:
	@echo "$(CYAN)Removing docker image...$(CLEAR)"
	docker rmi robotframework:$(DOCKER-VERSION)
	@echo "$(GREEN)DONE$(CLEAR)"

list-services:
	# Requires libghc-yaml-dev and jq packages to be installed
	@yaml2json docker-compose.yml | jq '.services | to_entries[] | .key'

chromedriver:
	curl https://chromedriver.storage.googleapis.com/2.40/chromedriver_linux64.zip -o chromedriver_linux64.zip
	unzip chromedriver_linux64.zip
	rm chromedriver_linux64.zip

test: $(VENV) chromedriver
	$(PIP) install -r requirements-robotframework.txt selenium eyes-selenium
	PATH=${PATH}:. $(VENV)/bin/robot -d robot/results/ -i ready -v BROWSER:chrome -v ENVIRONMENT:qa robot/tests/Springster-Demo-Site.robot


