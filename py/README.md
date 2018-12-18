## About

Simple test of few RAML Python parsers. Tests simply try to parse a set of examples and report if parser returned an error.

A fine collection of RAML files can be composed each containing one/few RAML features to test those in isolation.

Uses [raml-tck](https://github.com/raml-org/raml-tck/tree/master/tests/raml-1.0) as a source of RAML for tests.

NOTE: If file name contains "invalid" parsing of it is expected to fail.

## Install & run

```sh
$ git clone git@github.com:postatum/raml-parsers-test-py.git
$ cd raml-parsers-test-py
$ pip install -r requirements.txt
$ pip install .
$ raml-test-py --parser PARSER_NAME
```

## Options

Help:
```sh
$ raml-test-py -h
```

Parser:
```sh
$ raml-test-py --parser ramlfications/pyraml
```

Verbose output (prints errors) (defaults to `false`):

```sh
$ raml-test-py --parser PARSER_NAME --verbose

```
