package main

import (
	"log"
	"os"
	"path/filepath"
	"strings"
)

func writeToCSV(relOutPath string, summ *Summary) {
	if len(summ.Data) > 0 {
		writeToCfg(relOutPath, summ)

		filePath := filepath.Join(relOutPath, "summaries.csv")
		dataString := strings.Join(summ.Data, "\n")

		f, errOpen := os.OpenFile(filePath, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
		checkError(errOpen)
		defer f.Close()

		fileInfo, errFi := os.Stat(filePath)
		checkError(errFi)
		if fileInfo.Size() == 0 {
			_, errH := f.WriteString(summ.Header)
			checkError(errH)
		}
		_, errW := f.WriteString("\n" + dataString)
		checkError(errW)
		f.Sync()
	}
}

func writeToCfg(relOutPath string, summ *Summary) {
	cfg, errC := os.Create("last_updated.cfg")
	checkError(errC)
	defer cfg.Close()

	dateStr := summ.NextDate.String()
	_, errW := cfg.WriteString(dateStr)
	checkError(errW)
	cfg.Sync()
}

func checkError(err error) {
	if err != nil {
		log.Panic(err)
	}
}
