#!/bin/bash

############################################################################
#
#	This program is free software; you can redistribute it and/or modify
#  	it under the terms of the GNU General Public License as published by
#  	the Free Software Foundation; either version 2, or (at your option)
#  	any later version.
#
#	Program to submit pcap files to elasticsearch by using the program
#	zeek and zeek2es.py from a directory
#
#	Author: Fernando Burrieza Galan
#
#	Version: 2.5
#
#	Since: 04/04/2022
#
###########################################################################

# Error checking
if [ "$#" -lt 1 ]; then
  echo "Usage: $0 /Path_to_folder" >&2
  echo >&2
  echo "Example:" >&2
  echo "$0 /usr/local/var/logs" >&2
  exit 1
fi


# Declare Variables
FOLDER="$1"
NEW_FOLDER="$1zeekLogs"
zeek2es_path=~/zeek2es/zeek2es.py
pythoncmd="python3"
script=~/zeek2es/dnp3_anomaly.zeek


# Move to working folder
cd $FOLDER

# Check new folder
if [ -d "$NEW_FOLDER" ]; then 
 # Logs folder, so we don't generate new folder
 echo "Folder $NEW_FOLDER already exists. Overwrite it."
else
 # Create new folder to store new files
 echo "Create new folder to store the log files: $NEW_FOLDER" 
 mkdir "$NEW_FOLDER"
fi
echo ""

# Only choose .pcap files
FILES=*.pcap
# Only choose .log files to es
LOGS=*.log

#Iterate each file in our input folder
for f in $FILES
do
 # Generate only the filename without complete path
 filename=$(basename -- "$f")
 filename1="${filename%.*}"
 OUTPUT_LOGS="$NEW_FOLDER/$filename1"
 
 # Check if this file has already logs (I assume that it's submitted to es)
 if [ -d "$OUTPUT_LOGS" ]; then
  # File Exists, so we iterate to the next item
  echo "Folder $OUTPUT_LOGS already exists. Iterate to the next file ..."
  continue
 fi
 # The program will create the logs for this program 
 echo "Converting $filename1 pcap file..."
 # Create new folder to store the logs of the file
 mkdir "$OUTPUT_LOGS"
 
 # Use zeek command to generate the logs
 zeek -C -r $f $script
 
 # Move logs to the output directory
 mv *.log "$OUTPUT_LOGS"
 # Move to the new folder
 cd $OUTPUT_LOGS
 
 # Submit the logs into elasticSearch
 for logfile in $LOGS
 do
  logname=$(basename -- "$logfile")
  logname1="${logname%.*}"
  echo "	Sumbitting $logname1 log to elasticSearch"
   
  # Check the name of the log to create keywords for analysis
  if [[ $logname1 == "conn" ]] 
  then
   # Invoke python program to submit into elasticSearch with conn keywords
   $pythoncmd $zeek2es_path $logfile -k "proto" "history" "uid" "service" "conn_state"
  elif [[ $logname1 == "dnp3" ]]
  then
   # Invoke python program to submit into elasticSearch with dnp3 keywords
   $pythoncmd $zeek2es_path $logfile -k "fc_reply" "fc_request" "uid" 
  elif [[ $logname1 == "packet_filter" ]]
  then
   # Invoke python program to submit into elasticSearch with packet_filter keywords
   $pythoncmd $zeek2es_path $logfile -k "node" "filter"
  elif [[ $logname1 == "weird" ]]
  then
   # Invoke python program to submit into elasticSearch with weird keywords
   $pythoncmd $zeek2es_path $logfile -k "addl" "name" "peer" "source" "uid"
  else
   # Invoke python program to submit into elasticSearch without keywords
   $pythoncmd $zeek2es_path $logfile
  fi
  done
 # Come back to previous folder to generate the next logs
 cd $FOLDER
 
 # sleep in order to store the files in the corresponding folder
 sleep 0.1
 echo ""
done
