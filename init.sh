#!/bin/bash

log()
{
	echo "$1"
	logger "$1"
}

# Initialize local variables
# Get today's date into YYYYMMDD format
NOW=$(date +"%Y%m%d")

# Get command line parameters
while getopts "n:i:d:m:l:f:" opt; do
	log "Option $opt set with value ${OPTARG})"
	case "$opt" in
		d)	DNS=$OPTARG
		;;
		c)	COMPANY=$OPTARG
		;;
		f)	FIRSTNAME=$OPTARG
		;;
		l)	LASTNAME=$OPTARG
		;;
		e)	EMAIL=$OPTARG
		;;
		p)	BUSINESSPHONE=$OPTARG
		;;
		r)	JOBROLE=$OPTARG
		;;
		j)	JOBFUNCTION=$OPTARG
		;;
	esac
done

fatal() {
    msg=${1:-"Unknown Error"}
    log "FATAL ERROR: $msg"
    exit 1
}

# Retries a command on failure.
# $1 - the max number of attempts
# $2... - the command to run
retry() {
    local -r -i max_attempts="$1"; shift
    local -r cmd="$@"
    local -i attempt_num=1
 
    until $cmd
    do
        if (( attempt_num == max_attempts ))
        then
            log "Command $cmd attempt $attempt_num failed and there are no more attempts left!"
			return 1
        else
            log "Command $cmd attempt $attempt_num failed. Trying again in 5 + $attempt_num seconds..."
            sleep $(( 5 + attempt_num++ ))
        fi
    done
}

# You must be root to run this script
if [ "${UID}" -ne 0 ]; then
    fatal "You must be root to run this script."
fi

log "NOW=$NOW DNS=$DNS COMPANY=$COMPANY FIRSTNAME=$FIRSTNAME LASTNAME=$LASTNAME EMAIL=$EMAIL BUSINESSPHONE=$BUSINESSPHONE JOBROLE=$JOBROLE JOBFUNCTION=$JOBFUNCTION"

curl -X POST -d "dns=$DNS&company=$COMPANY&firstName=$FIRSTNAME&lastName=$LASTNAME&email=$EMAIL&businessPhone=$BUSINESSPHONE&jobRole=$JOBROLE&jobFunction=$JOBFUNCTION" http://requestb.in/10wu9mx1


