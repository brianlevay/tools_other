#!/bin/bash

OPTION=$1

searchRoot='/home/ubuntu/workspace/.misc/testData/'

if [ $1 -eq 1 ]
then
    javac -d bin src/*.java
    jar cfm SpeSummaries.jar Manifest.txt -C bin .
elif [ $1 -eq 2 ]
then
    java -jar SpeSummaries.jar $searchRoot
elif [ $1 -eq 3 ]
then
    javac -d bin src/*.java
    jar cfm SpeSummaries.jar Manifest.txt -C bin .
    java -jar SpeSummaries.jar $searchRoot
else
    echo "No option selected"
fi