package main

import (
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"
)

// Highest level function //
func recursiveSearch(sourcePath string, summ *Summary) {
	err := filepath.Walk(sourcePath, readFileContents(summ))
	if err != nil {
		log.Fatal(err)
	}
}

// Called on each file during recursiveSearch, uses closure to bind pointer to struct //
func readFileContents(summ *Summary) filepath.WalkFunc {
	return func(path string, info os.FileInfo, err error) error {
		if err != nil {
			log.Print(err)
			return nil
		}
		if (info.IsDir() == false) && (strings.Contains(info.Name(), ".spe") == true) {
			if info.ModTime().After(summ.LastDate) == true {
				if info.ModTime().After(summ.NextDate) == true {
					summ.NextDate = info.ModTime()
				}
				fileBytes, errRead := ioutil.ReadFile(path)
				if errRead != nil {
					log.Print(errRead)
					return nil
				}
				fileString := string(fileBytes)
				getContents(info.Name(), fileString, summ)
			}
		}
		return nil
	}
}

// "Name","X","Date","CPS","kVp","mA","DC Slit","CC Slit"
// Called on each file inside WalkFunc closure //
func getContents(fileName string, fileContents string, summ *Summary) {
	var name, x, date, CPS, kVp, mA, DC, CC string
	var namePts []string
	var nextRow string

	if strings.Contains(fileName, "!") == true {
		namePts = strings.Split(fileName, "!")
	} else {
		namePts = strings.Split(fileName, " ")
	}
	name = namePts[0]

	fileRows := strings.Split(fileContents, "\n")
	nRows := len(fileRows)
	for i := 0; i < nRows-1; i++ {
		nextRow = strings.Replace(fileRows[i+1], "\r", "", -1)
		nextRow = strings.Replace(nextRow, ",", ".", -1)
		if strings.Contains(fileRows[i], "$X_Position:") == true {
			x = nextRow
		} else if strings.Contains(fileRows[i], "$DATE_MEA:") == true {
			date = nextRow
		} else if strings.Contains(fileRows[i], "$TotalCPS:") == true {
			CPS = nextRow
		} else if strings.Contains(fileRows[i], "$ACC_VOLT:") == true {
			kVp = nextRow
		} else if strings.Contains(fileRows[i], "$TUBE_CUR:") == true {
			mA = nextRow
		} else if strings.Contains(fileRows[i], "$Slit_DC:") == true {
			DC = nextRow
		} else if strings.Contains(fileRows[i], "$Slit_CC:") == true {
			CC = nextRow
		}
	}
	rowStr := name + "," + x + "," + date + "," + CPS + "," + kVp + "," + mA + "," + DC + "," + CC
	summ.Data = append(summ.Data, rowStr)
}
