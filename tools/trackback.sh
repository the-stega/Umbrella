#!/bin/sh
#iPhone support
#
TRACKBACK_WRITE() { 
	if [ ${LINK}x = "x" ]; then
		echo "No link to trackback"
	    return
	fi
	MAIL_SUBJECT="Post from your Phone at ${TITLESTAMP}"
	EMAILMESSAGE="${WORKDIR}/scratch/emailmessage.txt"
	echo "Howdy, your post has been successfully received:"> $EMAILMESSAGE
	echo "${SUBJECT}"> $EMAILMESSAGE
	echo "You can use this link to share your post with others:" >>$EMAILMESSAGE
	echo "${LINK}" >>$EMAILMESSAGE
	# send an email using /bin/mail
	/usr/bin/mail -s "$MAIL_SUBJECT" "$EMAIL" < $EMAILMESSAGE
}