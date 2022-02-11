#!/bin/bash

# set the path for the file

file="file.txt"

#Check whether the file exists , is readable and has data 

if [[ -e ${file} ]] && [[ -r ${file} ]] && [[ -s ${file} ]]

then
	#execute this code if the file meets the condition 

	echo "file is good"

else 

	#execute this code if the file does not meet the condition

	echo "file is bad"

fi 
