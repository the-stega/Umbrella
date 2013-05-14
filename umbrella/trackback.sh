#!/bin/sh
#iPhone support
#
TRACKBACK_WRITE() { 
}
Was it a movie or an image?

SUBJECT="Post from your Phone at ${TITLESTAMP}"
EMAILMESSAGE="${WORKDIR}/scratch/emailmessage.txt"
echo "Howdy, your post has been successfully received:"> $EMAILMESSAGE
echo "You can use this link to share your post with others:" >>$EMAILMESSAGE
echo "${LINK}" >>$EMAILMESSAGE
# send an email using /bin/mail
/bin/mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE
