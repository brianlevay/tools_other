package main

import (
	"io/ioutil"
	"log"
	"time"
)

func lastDate() time.Time {
	var lastTime time.Time
	defaultTime := time.Date(2000, time.January, 01, 01, 0, 0, 0, time.UTC)
	defaultDateFmt := "2006-01-02 15:04:05.999999999 -0700 MST" // used by Time.String() //

	fileBytes, errRead := ioutil.ReadFile("last_updated.cfg")
	if errRead != nil {
		log.Println("Error reading 'last_updated.cfg'")
		lastTime = defaultTime
	} else {
		fileStr := string(fileBytes)
		dateFromCfg, errParse := time.Parse(defaultDateFmt, fileStr)
		if errParse != nil {
			log.Println("Error parsing time from 'last_updated.cfg'")
			lastTime = defaultTime
		} else {
			lastTime = dateFromCfg
		}
	}
	return lastTime
}
