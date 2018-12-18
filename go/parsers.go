package main

import (
	"fmt"
	jumpscale "github.com/postatum/go-raml/raml"
	tsaikd "github.com/tsaikd/go-raml-parser/parser"
	goraml "gopkg.in/raml.v0" // github.com/go-raml/raml
)

// Parser is a parsing type function
type Parser func(string) (error, bool)

func recovery() {
	if r := recover(); r != nil {
		fmt.Println("PANIC:", r)
	}
}

// Jumpscale runs jumpscale/go-raml/raml parser
func Jumpscale(fpath string) (error, bool) {
	defer recovery()
	apiDef := &jumpscale.APIDefinition{}
	return jumpscale.ParseFile(fpath, apiDef), true
}

// Goraml runs go-raml/raml parser
func Goraml(fpath string) (error, bool) {
	defer recovery()
	_, err := goraml.ParseFile(fpath)
	return err, true
}

// Tsaikd runs tsaikd/go-raml-parser/parser parser
func Tsaikd(fpath string) (error, bool) {
	defer recovery()
	ramlParser := tsaikd.NewParser()
	_, err := ramlParser.ParseFile(fpath)
	return err, true
}
