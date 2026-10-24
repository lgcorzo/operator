//go:build vendor
// +build vendor

package main

// This file exists to trick "go mod vendor" to include "main" packages or modules.

import (
	_ "github.com/klauspost/compress"
)

func main() {}
