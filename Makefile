ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
REPORTER_DIR:=$(ROOT_DIR)/html-reporter
JS_RUNNER_DIR:=$(ROOT_DIR)/js
PY_RUNNER_DIR:=$(ROOT_DIR)/py
RB_RUNNER_DIR:=$(ROOT_DIR)/rb
GO_RUNNER_DIR:=$(ROOT_DIR)/go
GO_PROJECT_DIR:=$(GOPATH)/src/github.com/raml-org/raml-tck-runner-go
PY_ENV:=venv

.ONESHELL:
all: clean install report generate-html

all-js:	install-html-reporter \
		install-js \
		report-js \
		generate-html

all-py:	install-html-reporter \
		install-py \
		report-py \
		generate-html

all-rb:	install-html-reporter \
		install-rb \
		report-rb \
		generate-html

all-go:	install-html-reporter \
		install-go \
		report-go \
		generate-html

install: install-html-reporter \
		 install-js \
		 install-py \
		 install-rb \
		 install-go

install-html-reporter:
	cd $(REPORTER_DIR)
	npm install .

install-js: clean-js
	cd $(JS_RUNNER_DIR)
	npm install .
	# IMPORTANT:
	#
	# Remove linking when webapi-parser is hosted on NPM and add it
	# as NPM dependency to js/package.json#dependencies:
	# 	"webapi-parser": "^0.0.1"
	#
	# Meanwhile your webapi-parser project must be at the same level
	# as raml-tck-runner project.
	npm link $(ROOT_DIR)/../webapi-parser/js/module/

create-virtualenv:
	sudo pip install virtualenv
	cd $(PY_RUNNER_DIR)
	virtualenv $(PY_ENV)

install-py: clean-py create-virtualenv
	cd $(PY_RUNNER_DIR)
	. $(PY_ENV)/bin/activate
	pip install -r requirements.txt
	# Install with -e so path to reports is resolved properly
	pip install -e .

install-rb:
	cd $(RB_RUNNER_DIR)
	bundle install

install-go:
	# Link go runner folder to GOPATH so it works like proper Go project
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

generate-html:
	cd $(REPORTER_DIR)
	node src/index.js

clean: clean-js clean-py
	rm -f $(ROOT_DIR)/reports/json/*
	rm -f $(ROOT_DIR)/reports/html/*.html

clean-js:
	rm -rf $(JS_RUNNER_DIR)/node_modules

clean-py:
	rm -rf $(PY_RUNNER_DIR)/$(PY_ENV)
