ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
REPORTER_DIR:=$(ROOT_DIR)/html-reporter
JS_RUNNER_DIR:=$(ROOT_DIR)/js
PY_RUNNER_DIR:=$(ROOT_DIR)/py
RB_RUNNER_DIR:=$(ROOT_DIR)/rb
GO_RUNNER_DIR:=$(ROOT_DIR)/go
GO_PROJECT_DIR:=$(GOPATH)/src/github.com/raml-org/raml-tck-runner-go
PY_ENV:=venv

.ONESHELL:
all: install report generate-html browse

install: install-html-reporter \
		 install-js \
		 install-py \
		 install-rb \
		 install-go

create-virtualenv:
	sudo pip install virtualenv
	cd $(PY_RUNNER_DIR)
	virtualenv $(PY_ENV)

install-html-reporter:
	cd $(REPORTER_DIR)
	npm install .

install-js:
	cd $(JS_RUNNER_DIR)
	npm install .
	# Remove when webapi-parser is hosted on NPM and instead add
	# this line to js/package.json#dependencies:
	# "webapi-parser": "^0.0.1"
	npm link /home/post/projects/webapi-parser/js/module/

install-py: create-virtualenv
	cd $(PY_RUNNER_DIR)
	. $(PY_ENV)/bin/activate
	pip install -r requirements.txt
	# Install with -e so path to reports is resolved properly
	pip install -e .

install-rb:
	cd $(RB_RUNNER_DIR)
	bundle install

install-go:
	mkdir -p $(GO_PROJECT_DIR)
	rm -rf $(GO_PROJECT_DIR)
	ln -s $(GO_RUNNER_DIR) $(GO_PROJECT_DIR)

report: report-js \
		report-py \
		report-rb \
		report-go

report-js:
	cd $(JS_RUNNER_DIR)
	node src/index.js --parser raml-1-parser
	node src/index.js --parser amf-client-js
	node src/index.js --parser webapi-parser

report-py:
	cd $(PY_RUNNER_DIR)
	. $(PY_ENV)/bin/activate
	raml-test-py --parser ramlfications
	raml-test-py --parser pyraml-parser

report-rb:
	cd $(RB_RUNNER_DIR)
	ruby main.rb --parser brujula
	ruby main.rb --parser raml-rb

report-go:
	cd $(GO_RUNNER_DIR)
	go run *.go -parser jumpscale
	go run *.go -parser go-raml
	# Ignore this parser because it causes unrecoverable fatal error.
	# go run *.go -parser tsaikd

generate-html:
	cd $(REPORTER_DIR)
	node src/index.js

browse:
	browse $(ROOT_DIR)/reports/html/index.html

clean:
	rm $(ROOT_DIR)/reports/json/*
	rm $(ROOT_DIR)/reports/html/*.html
	rm -rf $(JS_RUNNER_DIR)/node_modules
	rm -rf $(PY_RUNNER_DIR)/$(PY_ENV)
