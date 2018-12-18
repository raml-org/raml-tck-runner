package main

import (
	"errors"
	"flag"
	"fmt"
)

func main() {
	parserFl := flag.String(
		"parser", "jumpscale",
		"Parser to test. Supported: jumpscale, goraml, tsaikd.")
	verboseFl := flag.Bool(
		"verbose", false,
		"Verbose mode. Parsing errors will be printed.")
	flag.Parse()

	verbose := *verboseFl
	parsers := map[string]Parser{
		"jumpscale": Jumpscale,
		"goraml":    Goraml,
		"tsaikd":    Tsaikd,
	}
	parser, ok := parsers[*parserFl]
	if !ok {
		fmt.Println("Not supported parser. See help (-h).")
		return
	}

	examplesFl := CloneTckRepo()
	fileList, err := ListRamls(examplesFl)
	if err != nil {
		fmt.Printf("Failed to list RAML files: %s\n", err)
		return
	}

	var result string
	var shouldFail bool
	var countKey string
	count := map[string]map[string]int{
		"valid":   {"passed": 0, "total": 0},
		"invalid": {"passed": 0, "total": 0},
	}

	for _, fpath := range fileList {
		fmt.Printf("> Parsing %s: ", fpath)
		shouldFail = ShouldFail(fpath)
		if shouldFail {
			countKey = "invalid"
		} else {
			countKey = "valid"
		}
		count[countKey]["total"]++
		err, notPanic := parser(fpath)
		if !notPanic {
			continue
		}
		failed := err != nil
		if shouldFail {
			failed = !failed
			if err == nil {
				err = errors.New(
					"Parsing expected to fail but succeeded")
			}
		}
		result = "OK"
		if failed {
			result = "FAIL"
		} else {
			count[countKey]["passed"]++
		}
		fmt.Printf("%s\n", result)
		if verbose && err != nil {
			fmt.Println(err.Error())
		}
	}
	tmpl := "\nPassed/Total: %d/%d (valid: %d/%d, invalid: %d/%d)\n"
	fmt.Printf(
		tmpl, count["valid"]["passed"]+count["invalid"]["passed"], len(fileList),
		count["valid"]["passed"], count["valid"]["total"],
		count["invalid"]["passed"], count["invalid"]["total"])
}
