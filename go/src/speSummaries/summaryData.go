package main

import (
	"time"
)

type Summary struct {
	LastDate time.Time
	NextDate time.Time
	Data     []string
	Header   string
}

func NewSummary(lastDate time.Time) *Summary {
	summ := new(Summary)
	summ.Header = "Name,X,Date,CPS,kVp,mA,DC Slit,CC Slit"
	summ.LastDate = lastDate
	summ.NextDate = lastDate
	return summ
}
