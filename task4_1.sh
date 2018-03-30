#!/bin/bash

apt-get update && apt-get install dmidecode lsb-release e2fsprogs procps sed gawk -y

SED=$(which sed)
AWK=$(which awk)
GREP=$(which grep)
ECHO=$(which echo)
WC=$(which wc)
CAT=$(which cat)
TOP=$(which top)
DMIDECODE=$(which dmidecode)
USERS=$(which users)
UPTIME=$(which uptime)
TUNE2FS=$(which tune2fs)
DF=$(which df)
TAIL=$(which tail)
CUT=$(which cut)
UNAME=$(which uname)
LSB_RELEASE=$(which lsb_release)

CPU=$($GREP "model name" /proc/cpuinfo | $AWK -F: '{print $2}' | $SED '1s/^.//')
RAM=$(free -m | $GREP Mem | $AWK '{print $2}')
BM=$($DMIDECODE -s baseboard-manufacturer)
   if [ -z "$BM" ] ;
	then BM="Unknown";
   fi
BPN=$($DMIDECODE -s baseboard-product-name)
   if [ -z "$BPN" ] ;
	then BPN="Unknown";
   fi
SSN=$($DMIDECODE -s system-serial-number)
    if [ -z "$SSN" ] || [ "$SSN" == "Not Specified" ] ;
        then SSN="Unknown";
   fi

OS_DISTRIBUTION=$(${LSB_RELEASE} -a 2>/dev/null | $GREP Description | $AWK -F: '{print $2}' | $SED 's/[\t]*//')
KERNEL_VERSION=$($UNAME -r)
INSTALLATION_DATE=$(fs=$($DF / | $TAIL -1 | $CUT -f1 -d' ') && $TUNE2FS -l $fs | $GREP "Filesystem created" | $AWK -F "       " '{print $2}')
HOSTNAME=$(hostname -f)
UPTIME=$($UPTIME -p | $SED 's/up//' | $SED 's/^.//')
PROCESSES_NUMBER=$($TOP -n 1 | $GREP Tasks | $AWK '{print $2}')
USERS_NUMBER=$($USERS | wc -w)

function_interfces () {
for INTERFACE in `ip addr sh | $GREP -E ^[0-9] | $AWK '{print $2}' | $AWK -F: '{print $1}'`;
	do VARIABLE=$(ip addr sh | $GREP -w $INTERFACE | $GREP inet | $AWK '{print $2}');
		if [ -z "$VARIABLE" ]; then VARIABLE="-"; fi;
	   $ECHO $INTERFACE: $VARIABLE;
       done
}

CURRENT_PWD="$(dirname $0)"
#CURRENT_PWD="$( cd "$(dirname "$0")" ; pwd -P )"

$CAT /dev/null > ${CURRENT_PWD}/task4_1.out

$ECHO "---Hardware--" >> ${CURRENT_PWD}/task4_1.out
$ECHO "CPU": "$CPU" >> ${CURRENT_PWD}/task4_1.out
$ECHO "RAM": "${RAM}MB" >> ${CURRENT_PWD}/task4_1.out
$ECHO "Motherboard": "$BM $BPN" >> ${CURRENT_PWD}/task4_1.out
$ECHO "System Serial Number": "$SSN" >> ${CURRENT_PWD}/task4_1.out

$ECHO "---System---" >> ${CURRENT_PWD}/task4_1.out
$ECHO "OS Distribution": "${OS_DISTRIBUTION}" >> ${CURRENT_PWD}/task4_1.out
$ECHO "Kernel version": "${KERNEL_VERSION}" >> ${CURRENT_PWD}/task4_1.out
$ECHO "Installation date": ${INSTALLATION_DATE} >> ${CURRENT_PWD}/task4_1.out
$ECHO "Hostname": $HOSTNAME >> ${CURRENT_PWD}/task4_1.out
$ECHO "Uptime": $UPTIME >> ${CURRENT_PWD}/task4_1.out
$ECHO "Processes running": ${PROCESSES_NUMBER} >> ${CURRENT_PWD}/task4_1.out
$ECHO "Users logged in": ${USERS_NUMBER} >> ${CURRENT_PWD}/task4_1.out

$ECHO "---Network---" >> ${CURRENT_PWD}/task4_1.out
function_interfces >> ${CURRENT_PWD}/task4_1.out
