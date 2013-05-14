#!/bin/sh
#iPhone support
#
TRACKBACK_WRITE() { 
if [ $LINKx = x ]
then
    return
fi
MSUBJECT="Post from your Phone at ${TITLESTAMP}"
EMAILMESSAGE="${WORKDIR}/scratch/emailmessage.txt"
echo "Howdy, your post has been successfully received:"> $EMAILMESSAGE
echo "${SUBJECT}"> $EMAILMESSAGE
echo "You can use this link to share your post with others:" >>$EMAILMESSAGE
echo "${LINK}" >>$EMAILMESSAGE
# send an email using /bin/mail
/bin/mail -s "$MSUBJECT" "$EMAIL" < $EMAILMESSAGE
}