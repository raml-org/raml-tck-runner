## About

Simple test of few RAML Ruby parsers. Tests simply try to parse a set of examples and report if parser returned an error.

Reports are saved to `raml-tck-runner/reports/json/<PARSER_NAME>.json`.

A fine collection of RAML files can be composed each containing one/few RAML features to test those in isolation.

Uses [raml-tck](https://github.com/raml-org/raml-tck/tree/master/tests/raml-1.0) as a source of RAML for tests.

NOTE: If file name contains "invalid" parsing of it is expected to fail.

## Install

```sh
$ git clone git@github.com:raml-org/raml-tck-runner.git
$ cd raml-parsers-test/rb
$ bundle install
```

## Run

```sh
$ ruby main.rb --parser PARSER_NAME
```

## Options

Help:
```sh
$ ruby main.rb -h
```

Parser:
```sh
$ ruby main.rb --parser brujula/raml-rb
```
