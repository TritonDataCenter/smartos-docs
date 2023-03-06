export PATH:=$(PWD)/node_modules/.bin:$(PWD)/py-venv/bin/:$(PATH)
SHELL:=/bin/bash

.PHONY: clean deps deploy serve

deps: node_modules py-venv

node_modules: package.json
	npm install

py-venv: requirements.txt
	virtualenv py-venv
	source py-venv/bin/activate; pip install -r requirements.txt

check:
	sh -c "markdownlint-cli2 **/docs/*.md"

build:
	sh -c "mkdocs build"

serve:
	sh -c "mkdocs serve"

clean:
	rm -rf mode_modules py-venv
