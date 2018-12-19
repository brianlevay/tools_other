package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
)

func openBrowser(relOutPath string) {
	var err error
	cwd, err := os.Getwd()
	if err != nil {
		log.Print(err)
		return
	}
	htmlPath := filepath.Join(cwd, relOutPath, "plot.html")
	fmt.Println(htmlPath)

	switch runtime.GOOS {
	case "linux":
		err = exec.Command("xdg-open", htmlPath).Start()
	case "windows":
		err = exec.Command("rundll32", "url.dll,FileProtocolHandler", htmlPath).Start()
	default:
		err = fmt.Errorf("Cannot open browser")
	}
	if err != nil {
		log.Print(err)
	}
}
