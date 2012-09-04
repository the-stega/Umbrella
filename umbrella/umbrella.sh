#!/bin/sh
#
# Umbrella 3.0 smart phone to RSS
# Take a picture or video with your phone and post it to your private (non-cloud) photo/vid blog
# Copyright 2004, 2007, 2011, 2012 by stega:  stega@stega.org
#
#
# Import the variable file
. variables.txt
. device/${PHONE}.sh
. write-xml.sh

#This is for FreeBSD	
LOCK_STUFF () {
	retries=5
	while true ; do 
		if mktemp /tmp/umbrella.lock
		then 
			echo "Made a lockfile."	
			break
		else
			if [ $retries -eq 0 ]		
			then
				echo "Removing stale lockfile."	
				UNLOCK_STUFF
				continue
			else	
				echo "Waiting for lockfile"
				sleep 1
				retries=`expr $retries - 1`
			fi		
		fi	
	done
}

UNLOCK_STUFF () {
	rm /tmp/umbrella.lock
	echo "Removing current lockfile."	
}


cd ${WORKDIR}

LOCK_STUFF

# Spam the message on standard input into a scratch file. Pull out the subject header field, then explode the message into its various parts.
TEMPFILE=`mktemp ${TEMP_TEMPLATE}`
cat > ${TEMPFILE}
SUBJECT=`grep -i \^subject: ${TEMPFILE} | cut -c 10-100`
${MUNPACK} -q < ${TEMPFILE} > /dev/null 2> /dev/null
echo $SUBJECT > ${WORKDIR}/${TIMESTAMP}.title
rm -f ${TEMPFILE} 

# Ask the phone-specific logic to work out what it's done
DO_FILE

XML_Header

if [ ${MODE}x = "imagex" ]; then
	XML_IMAGE ${OUTPUT_FILE}
else
	XML_MOVIE ${OUTPUT_FILE}
fi

CLEAN_XML_WRITE

UNLOCK_STUFF 
