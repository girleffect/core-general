VENV=./ve
PYTHON=$(VENV)/bin/python
PIP=$(VENV)/bin/pip

help:
	@echo  "usage: make <target>"
	@echo  "	docs-build: Build documents and place html output in docs root."


$(VENV):
	virtualenv $(VENV) -p python3.5


docs-build: $(VENV)
	$(PIP) install sphinx sphinx-autobuild
	# Backup the files needed to build the html.
	tar -cvf backup.tar docs/source docs/Makefile
	# Remove docs compeletely.
	rm -rf docs/
	# Restore backup files.
	tar -xvf backup.tar
	# Remove the tar file.
	rm backup.tar
	# Actually make html from index.rst
	$(MAKE) -C docs/ clean html
	# Drop all build files in doc root.
	cp -r docs/build/html/. docs/


clean-virtualenv:
	rm -rf $(VENV)
