#!/bin/bash -x

COMMAND="$1"

export PASSWORD=${PASSWORD}

export RUNCOMMAND=`echo ${COMMAND} | envsubst`
RUNCOMMAND="${RUNCOMMAND}"
echo "Running command ${RUNCOMMAND}" 
IPADDR=$(echo $1 | grep -Po '@\K.+?(?=/)')
echo "IP Address extracted=${IPADDR}" >> /var/log/syslog
CAM=$(echo $1 | grep -Po 'rtmp....*/.*/\K.*?(?=\ )')
echo "Cam extracted=${CAM}" >> /var/log/syslog
if [ -z "${RUNCOMMAND}" ]
then
	echo "Usage: runCommand.sh <command>"
	exit 1
fi

while [ 1==1 ]
do
	CHECK=$(ps -ef | grep "ffmpeg" | grep "${IPADDR}" | grep "${CAM}" | grep -v grep | grep -v "runCommand")
	if [ -z "${CHECK}" ]
        then
		${RUNCOMMAND} &
		PID=$!
		echo "PID: $PID"
        fi
	echo "Sleeping..."
	sleep 20
	echo "Checking to see if stream is up"
	CHECK=$(find /mnt/hls_ad/*/${CAM} -mmin -1 -name index.m3u8)
        if [ -z "${CHECK}" ]
        then
                kill -9 ${PID}
        fi
done
