ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
REPORTER_DIR:=$(ROOT_DIR)/html-reporter
JS_DIR:=$(ROOT_DIR)/js
GO_DIR:=$(ROOT_DIR)/go
PY_DIR:=$(ROOT_DIR)/py
RB_DIR:=$(ROOT_DIR)/rb

.ONESHELL:
all: install report generate-html browse

install: install-html-reporter \
		 install-js \
		 install-py \
		 install-go \
		 install-rb

install-html-reporter:
	cd $(REPORTER_DIR)
	npm install .

install-js:
	cd $(JS_DIR)
	npm install .
	# Remove when webapi-parser is hosted on NPM and instead add
	# this line to js/package.json#dependencies:
	# "webapi-parser": "^0.0.1"
	npm link /home/post/projects/webapi-parser/js/module/

install-py:
	cd $(PY_DIR)
	#

install-go:
	cd $(GO_DIR)
	#

install-rb:
	cd $(RB_DIR)
	#

report: report-js \
		report-py \
		report-go \
		report-rb

report-js:
	cd $(JS_DIR)
	node src/index.js --parser raml-1-parser
	node src/index.js --parser amf-client-js
	node src/index.js --parser webapi-parser

report-py:
	cd $(PY_DIR)
	#

report-go:
	cd $(GO_DIR)
	#

report-rb:
	cd $(RB_DIR)
	#

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
