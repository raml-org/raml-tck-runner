## About

Simple test of few RAML Go parsers. Tests simply try to parse a set of examples and report if parser returned an error.

Reports are saved to `raml-tck-runner/reports/json/<PARSER_NAME>.json`.

A fine collection of RAML files can be composed each containing one/few RAML features to test those in isolation.

Uses [raml-tck](https://github.com/raml-org/raml-tck/tree/master/tests/raml-1.0) as a source of RAML for tests.

NOTE: If file name contains "invalid" parsing of it is expected to fail.

## Install & run

```sh
$ git clone git@github.com:raml-org/raml-tck-runner.git
$ mkdir -p $GOPATH/src/github.com/raml-org/raml-tck-runner-go
$ ln -s ./raml-parsers-test/go $GOPATH/src/github.com/raml-org/raml-tck-runner-go
$ cd $GOPATH/src/github.com/raml-org/raml-tck-runner-go
```

## Run

```sh
$ go run *.go -parser PARSER_NAME
```

## Options

Help:

```sh
$ go run *.go -h
```

Parser (defaults to `jumpscale`):
```sh
$ go run *.go -parser jumpscale/go-raml/tsaikd
```
