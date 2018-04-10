#!/bin/bash

# Sensor program
SENSORPROG=/usr/bin/sensors

# Exit codes
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3

# Warning threshold
thresh_warn=80
# Critical threshold
thresh_crit=100
# Hardware to monitor
sensor=CPU


# See if we have sensors program installed and can execute it
if [[ ! -x "$SENSORPROG" ]]; then
	printf "\nIt appears you don't have sensors installed in $SENSORPROG\n"
	exit $STATE_UNKOWN
fi


# See if we have sensors program installed and can execute it
if [[ ! -x "$SENSOR" ]]; then
	printf "\nIt appears you don't have sensors $sensor\n"
	exit $STATE_UNKOWN
fi




#Get the temperature
TEMP=`${SENSORPROG} | grep "$sensor" | cut -d+ -f2 | cut -c1-2 | head -n1`


# And finally check the temperature against our thresholds
if [[ "$TEMP" != +([0-9]) ]]; then
	# Temperature not found for that sensor
	printf "No data found for that sensor ($sensor)\n"
	exit $STATE_UNKNOWN
	
  elif [[ "$TEMP" -gt "$thresh_crit" ]]; then
	# Temperature is above critical threshold
	echo "$sensor CRITICAL - Temperature is $TEMP"
	exit $STATE_CRITICAL

  elif [[ "$TEMP" -gt "$thresh_warn" ]]; then
	# Temperature is above warning threshold
	echo "$sensor WARNING - Temperature is $TEMP"
	exit $STATE_WARNING

  else
	# Temperature is ok
	echo "$sensor OK - Temperature is $TEMP"
	exit $STATE_OK
fi
exit 3