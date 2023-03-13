# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

# Copyright 2020 Joyent, Inc.
# Copyright 2023 MNX Cloud, Inc.

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
	curl -sf -L -o docs/CODE_OF_CONDUCT.md https://github.com/TritonDataCenter/illumos-joyent/raw/master/CODE_OF_CONDUCT.md
	sh -c "mkdocs build"

serve-loop:
	sh -c "while : ; do mkdocs serve ; sleep 1 ; done"

serve:
	sh -c "mkdocs serve"

clean:
	rm -rf mode_modules py-venv
