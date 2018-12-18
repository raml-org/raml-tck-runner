package main

import (
	"encoding/json"
	// "fmt"
	"io/ioutil"
	"os"
	// "os/exec"
	"path/filepath"
	"strings"
)

type manifest struct {
	Description string   `json:"description"`
	FilePaths   []string `json:"filePaths"`
}

// ListRamls lists RAML file in :folderPath: folder;
// Uses raml-tck manifest.json file
func ListRamls(folderPath string) ([]string, error) {
	fileList := []string{}
	manifestPath := filepath.Join(folderPath, "manifest.json")
	manifestFile, err := os.Open(manifestPath)
	defer manifestFile.Close()
	if err != nil {
		return fileList, err
	}
	byteValue, _ := ioutil.ReadAll(manifestFile)
	var m manifest
	json.Unmarshal(byteValue, &m)
	for _, fp := range m.FilePaths {
		fileList = append(fileList, filepath.Join(folderPath, fp))
	}
	return fileList, nil
}

// CloneTckRepo clones raml-tck repo and returns cloned repo path
func CloneTckRepo() string {
	targetDir := fmt.Sprintf("%s/raml-tck", os.TempDir())
	_ = os.RemoveAll(targetDir)
	fmt.Printf("Cloning raml-tc repo to %s\n", targetDir)
	gitRepo := "git@github.com:raml-org/raml-tck.git"
	cmd := exec.Command(
		"git", "clone", "-b", "rename-cleanup", gitRepo, targetDir)
	err := cmd.Run()
	if err != nil {
		panic(fmt.Sprintf("Failed to clone repo %s", gitRepo))
	}
	return fmt.Sprintf("%s/tests/raml-1.0", targetDir)
	// return "/home/post/projects/raml-tck/tests/raml-1.0/"  // DEBUG
}

// ShouldFail reports whether parsing of RAML file should fail
func ShouldFail(fpath string) bool {
	return strings.Contains(strings.ToLower(fpath), "invalid")
}
