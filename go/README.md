## About

Simple test of few RAML Go parsers. Tests simply try to parse a set of examples and report if parser returned an error.

A fine collection of RAML files can be composed each containing one/few RAML features to test those in isolation.

Uses [raml-tck](https://github.com/raml-org/raml-tck/tree/master/tests/raml-1.0) as a source of RAML for tests.

NOTE: If file name contains "invalid" parsing of it is expected to fail.

## Install & run as bin

```sh
$ go install github.com/postatum/raml-parsers-test-go
$ raml-parsers-test-go -parser PARSER_NAME
```

## Install & run raw code

```sh
$ git clone git@github.com:postatum/raml-parsers-test-go.git
$ cd raml-parsers-test-go
$ go run *.go -parser PARSER_NAME
```

## Options

Help:

```sh
$ raml-parsers-test-go -h
```

Parser (defaults to `jumpscale`):
```sh
$ raml-parsers-test-go -parser jumpscale/goraml/tsaikd
```

Verbose output (prints errors) (defaults to `false`):

```sh
$ raml-parsers-test-go -verbose
```
