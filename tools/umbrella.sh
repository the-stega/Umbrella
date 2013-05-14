#!/bin/sh
#
# Umbrella 3.0 smart phone to RSS
# Take a picture or video with your phone and post it to your private (non-cloud) photo/vid blog
# Copyright 2004, 2007, 2011, 2012 by stega:  stega@stega.org
#
#
# Import the variable file
. variables.txt
. file_handler.sh
. write_xml.sh
. trackback.sh

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

rm -rf ${WORKDIR}/scratch
# It's better to remove the old when you're about to write new.
mkdir -p scratch
# Spam the message on standard input into a scratch file. Pull out the subject header field, then explode the message into its various parts.
TEMPFILE=`mktemp ${TEMP_TEMPLATE}`
cat > ${TEMPFILE}
SUBJECT=`grep -i \^subject: ${TEMPFILE} | cut -c 10-100`
${MUNPACK} -q -C scratch < ${TEMPFILE} > /dev/null 2> /dev/null
#Assume largest file. (this is to deal with android multipart message wonkiness)
LARGEFILE=${WORKDIR}/scratch/`/bin/ls -S1 ${WORKDIR}/scratch | head -1`
echo $SUBJECT > ${WORKDIR}/${TIMESTAMP}.title 

rm -f ${TEMPFILE} 

#If Munpack finds no files:  use the place holder
if [ ${LARGEFILE}x = "x" ]; then
	LARGEFILE=${WORKDIR}/scratch/placeholder.jpg
	SUBJECT=`cat ${PLACEHOLDER_TXT}`
fi

# Ask the phone-specific logic to work out what it's done
DO_FILE

XML_Header

if [ ${MODE}x = "imagex" ]; then
	XML_IMAGE ${OUTPUT_FILE}
else
	XML_MOVIE ${OUTPUT_FILE}
fi

CLEAN_XML_WRITE

TRACKBACK_WRITE

UNLOCK_STUFF