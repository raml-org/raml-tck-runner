ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
REPORTER_DIR:=$(ROOT_DIR)/html-reporter
JS_RUNNER_DIR:=$(ROOT_DIR)/js
PY_RUNNER_DIR:=$(ROOT_DIR)/py
RB_RUNNER_DIR:=$(ROOT_DIR)/rb
GO_RUNNER_DIR:=$(ROOT_DIR)/go
GO_PROJECT_DIR:=$(GOPATH)/src/github.com/raml-org/raml-tck-runner-go
PY_ENV:=raml-tck-runner

.ONESHELL:
all: install report generate-html browse

install: install-html-reporter \
		 install-js \
		 install-py \
		 install-rb \
		 install-go

install-virtualenv:
	# ifndef $(shell mkvirtualenv 1> /dev/null)
	# 	sudo pip install virtualenv virtualenvwrapper
	# 	mkdir ~/.virtualenvs
	# 	export WORKON_HOME=$(HOME)/.virtualenvs
	# 	source /usr/local/bin/virtualenvwrapper.sh
	# 	export PIP_VIRTUALENV_BASE=$(WORKON_HOME)
	# endif
	# mkvirtualenv $(PY_ENV)

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

install-py: install-virtualenv
	cd $(PY_RUNNER_DIR)
	# workon $(PY_ENV)
	pip install -r requirements.txt
	pip install .

install-rb:
	cd $(RB_RUNNER_DIR)
	bundle install

install-go:
	cd $(GO_RUNNER_DIR)
	mkdir -p $(GO_PROJECT_DIR)
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
	raml-test-py --parser ramlfications
	raml-test-py --parser pyraml-parser

report-rb:
	cd $(RB_RUNNER_DIR)
	ruby main.rb --parser brujula
	ruby main.rb --parser raml-rb

report-go:
	cd $(GO_PROJECT_DIR)
	go run *.go -parser jumpscale
	go run *.go -parser go-raml
	# Ignore this parser because it causes unrecoverable fatal error.
	# go run *.go -parser tsaikd

generate-html:
	cd $(REPORTER_DIR)
	node src/index.js

browse:
	cd $(ROOT_DIR)
	browse reports/html/index.html

clean:
	cd $(ROOT_DIR)
	rm reports/json/*
	rm reports/html/*.html
