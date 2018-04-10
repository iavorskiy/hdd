#!/bin/bash


# Sensor program
SMARTCTL="/usr/sbin/smartctl"


SMARTOPTS="-H -l selftest -l error"

# Exit codes
OK=0 # All drives report good status or no hard drives installed
NONOK=1 # failed drive
UNKNOWN=2 # no S.M.A.R.T. capabilities

baddrives=()
# drives count. If there are no drives in the system, return STATE_OK
INDEX=0


if [[ ! -x ${SMARTCTL} ]] ; then
	echo "There is no SMARTCTL. Install smartmontools ."
	exit  $UNKNOWN
fi

# check the status of all drives
# if there are no disks, return STATE_OK
for drive in `ls /dev/sd{a..z} 2>/dev/null` ; do
	result=`sudo ${SMARTCTL} ${SMARTOPTS} $drive`
	overalhealth=`echo "$result" | grep result | awk '{print $6}'`


	if [[ -n "$overalhealth" && "$overalhealth" == "FAILED!" ]] ; then
		
		baddrives=(${baddrives[@]}  $drive)
		let INDEX+=1
	fi
done


# check for critical bad drives
if [[ ${#baddrives[@]} -gt 0 ]] ; then
	echo "S.M.A.R.T. CRITICAL - Drive(s) ${baddrives[@]} may fail within 24 hours."
	exit $NONOK
fi

echo "S.M.A.R.T. OK - All drives are healthy."
exit $OK
