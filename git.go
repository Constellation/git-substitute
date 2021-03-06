package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

func gitStatus() {
	output, err := exec.Command("git", "status").CombinedOutput()
	if err != nil {
		fmt.Println(string(output))
		os.Exit(1)
	}
}

func gitGrep(patternType string, options []string, paths []string) ([]byte, error) {
	command := append([]string{"grep"}, patternType)
	if len(paths) > 0 {
		options = append(options, paths...)
	}
	return exec.Command("git", append(command, options...)...).CombinedOutput()
}

func filesMatching(pattern *searchPattern, paths []string) []string {
	grepArgs := []string{"--files-with-matches", pattern.string()}
	output, err := gitGrep(pattern.grepArg(), grepArgs, paths)
	if err != nil {
		if len(output) != 0 {
			fmt.Println(string(output))
		}
		os.Exit(1)
	}
	splitOut := strings.Split(string(output), "\n")
	return splitOut[:len(splitOut)-1]
}
