#!/bin/bash
#
# Capture frames from ESPCAM
#
#

setup() {
	export myname=$(basename ${0})
	export camidx=${1:-"00"}
	export CAM=ESPCAM${camidx}
	export dest=${3:-"/mnt/USB64/capture"}
	export interval=${2:-15}s
}

usage() {
cat<<EOF

	usage: ${0} [camidx] [interval] [destdir] 
	
	Defaults:
		camidx   = "00"
		interval =  15
		destdir  =  ${dest}
	      
	${myname}     will record from ESPCAM00 (Default for camidx is 00)
	${myname} 01  will record from ESPCAM01
	${myname} 02 10 /tmp  will record from ESPCAM02 one picture every 10 seconds to /tmp
EOF
exit 0
}

 
setcampar() {
	curl "http://${CAM}/control?var=framesize&val=10"
	curl "http://${CAM}/control?var=quality&val=10"
	curl "http://${CAM}/control?var=awb&val=1"
	curl "http://${CAM}/control?var=wb_mode&val=0"
	
	#
	# Auto exposure Sensor + Auto exposure DSP on 
	#
	curl "http://${CAM}/control?var=aec&val=1"
	curl "http://${CAM}/control?var=aec2&val=1"
    curl "http://${CAM}/control?var=ae_level&val=0"
	
	#
	# Gain-Ceilling  Level 2  
	#
	#  from 0=2 to 6=128
	#
	curl "http://${CAM}/control?var=agc&val=1"
	curl "http://${CAM}/control?var=gainceilingl&val=2"
	
	#
	# whit- and blackpoint correction ON
	#
	curl "http://${CAM}/control?var=bpc&val=1"
	curl "http://${CAM}/control?var=wpc&val=1"

	curl "http://${CAM}/control?var=raw_gma&val=1"
	curl "http://${CAM}/control?var=lenc&val=12"
	curl "http://${CAM}/control?var=dcw&val=0"
	
	# curl "http://${CAM}/control?var=hmirror&val=0
	# curl "http://${CAM}/control?var=vflip&val=0"
}

#
#
#
[ ${1}"x" = "--usagex" ] && usage

setup

#
# capture frames.
# set camera parameter every 8 captures 
# (just in case someone called the camera wesite and changed something...)
#
while true
do
	setcampar
	for (( i=1; i<=8; i++ ))
	do  
		folder=${dest}/$(date +%y%m%d)
		[ -d ${folder} ] || mkdir -p ${folder}
		stamp=$(date +%y%m%d_%H%M%S)
		curl "http://${CAM}/capture" --output ${folder}/${CAM}-${stamp}.jpg
		sleep ${interval}
	done 
done

