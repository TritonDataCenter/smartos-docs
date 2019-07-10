export PATH:=$(PATH):$(PWD)/node_modules/.bin:$(PWD)/py-venv/bin/

deps: node_modules py-venv

node_modules: package.json
	npm install

py-venv: requirements.txt
	virtualenv-3.7 py-venv
	source py-venv/bin/activate; pip install -r requirements.txt

check:
	sh -c "markdownlint docs"

build:
	sh -c "mkdocs build"

serve:
	sh -c "mkdocs serve"
