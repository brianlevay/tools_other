package main

import (
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 3 {
		fmt.Println("Please enter both path arguments")
		return
	}
	sourcePath := os.Args[1]
	relOutPath := os.Args[2]
	lastUpdate := lastDate()

	fmt.Println("Processing...")
	summ := NewSummary(lastUpdate)
	recursiveSearch(sourcePath, summ)
	writeToCSV(relOutPath, summ)
	openBrowser(relOutPath)
	fmt.Println("Finished!")
}
