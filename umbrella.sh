#!/bin/sh
#
# Umbrella 2.0 iPhone to RSS
# Take a picture or video with your iPhone and post it to your private (non-cloud) photo/vid blog
# Copyright 2004, 2007, 2011 by stega:  stega@stega.org
# This script originally took data from a Sony Erickson 615 and pushed it out.  
# Now it functions with images from an iPhone.
# 2.0 added ability to rotate image based on EXIF data in image (IOS 3.0)
#
# If using with a non-iPhone, send an email message to yourself to determine the names and formats of the specific message components
# Requires mpack

##VARIABLES: YOU NEED TO CHANGE THESE FOR YOUR SETUP
# Configure your working directory:  this should be where the feed will actually live.
# If this is the first time you are running the script, make sure you create/touch feed.xml and old.xml and have created placeholder.txt and placeholder.jpg in your working directory
# This is also where you will put the index.php
WORKDIR="/home/www/Sites/stega.org/htdocs/mblog/Umbrella" 
#
# Configure your absolute/FQd URL for the above directory (no trailing /)
URL="http://www.stega.org/mblog/Umbrella"
#
# Configure your TLD (or whatever you want as the site root) 
SITE="http://www.stega.org"
#
# Configure your contact email: to be sure to include a real name value within the ()
EMAIL="stega@stega.org (stega)" 
#
#Path to file with any Comment/Copyright you want added to the EXIF--leave this empty if you do not wish to use (Not supported yet.)
#COMMENTS="/home/www/Sites/stega.org/htdocs/mblog/Umbrella/comments.txt"
#
# Timezone (as three letters)
TZ="PDT"
# 
# You should not need to change these
#use for name of image/title files
TIMESTAMP=`/bin/date '+%Y%m%d%H%M%S'`
#use for xml title info files
TITLESTAMP=`/bin/date '+%a-%d-%b-%Y-%H:%M'` 
#use for pubDate and lastBuild
DCSTAMP=`/bin/date '+%a, %d %b %Y %H:%M:%S'` 
TEMPFILE=`mktemp ${WORKDIR}/umbrella-mail.XXXXXX`
# These may need set if you have things installed elsewhere
MUNPACK="/usr/local/bin/munpack"
JPEGTRAN="/usr/local/bin/jpegtran"
EXIFPROBE="/usr/local/bin/exifprobe"
# 
JPG_OUTPUT() { 
#subroutine for manipulating inbound images
    # The name and format of the image may vary.  
    /bin/cp ${WORKDIR}/photo.JPG ${WORKDIR}/photoX1X.jpg 2> /dev/null
    # If something is broken: it will use the placeholder image.
    if [ ! -f ${WORKDIR}/photoX1X.jpg ]; then
	cp ${WORKDIR}/placeholder.jpg ${WORKDIR}/photoX1X.jpg;
    fi
    # Otherwise it's going to use the nice new image
    chmod 744 ${WORKDIR}/photoX1X.jpg;

    # Due to changes in how iPhones save images, we now need to pull 
    # out the Orientation from the EXIF data
    # right now this script uses EXIF which does not use a numeric value
    # This section is if you are using the EXIF data and a another app to rotate.  
    # jhead does this simply
    # The EXIF options from an iPhone photo are 1, 3, 6 or 8
    #
    ORIENTATION=`$EXIFPROBE -L photoX1X.jpg | grep Orientation | cut -d = -f 2`
    case $ORIENTATION in
        " 1 " )
    # camera was at the top left (landscape) so no transform needed
            ;;
        " 3 " )
    # camera was at the bottom right (portrait) so need to rotate
            mv photoX1X.jpg old-photoX1X.jpg
            ${JPEGTRAN} -trim -rotate 180 old-photoX1X.jpg > photoX1X.jpg
            rm old-photoX1X.jpg
            ;;
        " 6 " )
    # camera was at the right top (portrait) so need to rotate
            mv photoX1X.jpg old-photoX1X.jpg
            ${JPEGTRAN} -trim -rotate 90 old-photoX1X.jpg > photoX1X.jpg
            rm old-photoX1X.jpg 
            ;;
        " 8 " )
    # camera was at the bottom left (landscape) so need to rotate
            mv photoX1X.jpg old-photoX1X.jpg
            ${JPEGTRAN} -trim -rotate 270 old-photoX1X.jpg > photoX1X.jpg
            rm old-photoX1X.jpg
            ;;
    esac
# In addition to saving it to a permanent file named by the timestamp, it will also copy it to the current top image This is handy if you want to have a splash page that just links to the most current image
    cp ${WORKDIR}/photoX1X.jpg ${WORKDIR}/current-mblog.jpg;
    chmod 755 ${WORKDIR}/current-mblog.jpg; 
    mv ${WORKDIR}/photoX1X.jpg ${WORKDIR}/images/${TIMESTAMP}.jpg;
    /bin/rm ${WORKDIR}/photo* 2> /dev/null
    }  
MOV_OUTPUT(){ 
# subroutine to manipulate the inbound movie file.
    /bin/cp ${WORKDIR}/IMG_*.MOV ${WORKDIR}/IMGMOV_X1X.mov 2> /dev/null
    # If something is broken: it will use the placeholder image.
    if [ ! -f ${WORKDIR}/IMGMOV_X1X.mov ]; then
        cp ${WORKDIR}/placeholder.jpg ${WORKDIR}/IMGMOV_X1X.mov;
    fi
    # Otherwise it is going to use the nice new movie  
    chmod 744 ${WORKDIR}/IMGMOV_X1X.mov;
    mv ${WORKDIR}/IMGMOV_X1X.mov ${WORKDIR}/movies/${TIMESTAMP}.mov;
    /bin/rm ${WORKDIR}/IMG* 2> /dev/null
    }
#
XML_Header() {
# subroutine to build the xml header
#    cat <<XMLHEADER_TXT
#	<rss version="2.0">
#   	<channel>
#   	<title>Stega mBlog</title>
#       <link>${URL}</link>
#	<description>Things captured by a little phone</description>
#	<language>en-us</language>
# 	<lastBuildDate>${DCSTAMP} ${TZ}</lastBuildDate>
#	<generator>Umbrella 2.0</generator>
#    	<managingEditor>${EMAIL}</managingEditor>
#	<copyright>Copyright 2011, stega doggie and tree.</copyright>
#       <ttl>40</ttl> 
#	XMLHEADER_TXT

    echo "<rss version=\"2.0\">" >> ${WORKDIR}/feed.xml
    echo "<channel>" >> ${WORKDIR}/feed.xml
    echo "<title>Stega mBlog</title>" >> ${WORKDIR}/feed.xml
    echo "<link>${URL}</link>" >> ${WORKDIR}/feed.xml
    echo "<description>Things captured by a little phone</description>" >> ${WORKDIR}/feed.xml
    echo "<language>en-us</language>" >> ${WORKDIR}/feed.xml 
    echo "<lastBuildDate>${DCSTAMP} ${TZ}</lastBuildDate>"  >> ${WORKDIR}/feed.xml
    echo "<generator>Umbrella 2.0</generator>" >> ${WORKDIR}/feed.xml
    echo "<managingEditor>${EMAIL}</managingEditor>" >> ${WORKDIR}/feed.xml
    echo "<copyright>Copyright 2011, stega doggie and tree.</copyright>" >> ${WORKDIR}/feed.xml
    echo "<ttl>40</ttl>" >> ${WORKDIR}/feed.xml
    }    
#
XML_IMAGE(){ 
#subroutine to build xml for images
    echo "<item>" >> ${WORKDIR}/new.xml
    echo "<title>${TITLESTAMP}" `/bin/cat ${WORKDIR}/${TIMESTAMP}.title` "</title>" >>  ${WORKDIR}/new.xml
    echo "<link>${URL}/index.php</link>" >> ${WORKDIR}/new.xml
    echo "<description>" >> ${WORKDIR}/new.xml
    echo "&lt;img src=&quot;${URL}/images/${TIMESTAMP}.jpg&quot;" >> ${WORKDIR}/new.xml 
    echo "alt=&quot;${TITLESTAMP} `/bin/cat ${WORKDIR}/${TIMESTAMP}.title`&quot;&gt;" >> ${WORKDIR}/new.xml
    echo "</description>" >> ${WORKDIR}/new.xml
    echo "<guid>${URL}/images/${TIMESTAMP}.jpg</guid>" >> ${WORKDIR}/new.xml 
    echo "<author>${EMAIL}</author>" >> ${WORKDIR}/new.xml
    echo "<pubDate>${DCSTAMP} ${TZ}</pubDate>" >> ${WORKDIR}/new.xml
    echo "</item>" >> ${WORKDIR}/new.xml
}
XML_MOVIE(){ 
#subroutine to build xml for movies
    echo "<item>" >> ${WORKDIR}/new.xml
    echo "<title>${TITLESTAMP}" `/bin/cat ${WORKDIR}/${TIMESTAMP}.title` "</title>" >>  ${WORKDIR}/new.xml
    echo "<link>${URL}/index.php</link>" >> ${WORKDIR}/new.xml
    echo "<description>" >> ${WORKDIR}/new.xml
    echo "<![CDATA[ <object width=\"500\" height=\"500\">" >> ${WORKDIR}/new.xml
    echo "<param name=\"movie\" value=\"${URL}/movies/${TIMESTAMP}.mov\">" >> ${WORKDIR}/new.xml 
    echo "</param>" >> ${WORKDIR}/new.xml
    echo "<param name=\"autoplay\" value=\"false\">" >> ${WORKDIR}/new.xml
    echo "</param>" >> ${WORKDIR}/new.xml
    echo "<embed src=\"${URL}/movies/${TIMESTAMP}.mov\" type=\"application/quicktime\" wmode=\"transparent\" width=\"500\" height=\"500\">" >> ${WORKDIR}/new.xml
    echo "</embed>" >> ${WORKDIR}/new.xml
    echo "</object>" >> ${WORKDIR}/new.xml
    echo "<noembed>" >> ${WORKDIR}/new.xml
    echo "<a href=\"${URL}/movies/${TIMESTAMP}.mov\">Watch the movie...</a>" >> ${WORKDIR}/new.xml
    echo "</noembed>]]>" >> ${WORKDIR}/new.xml
    echo "</description>" >> ${WORKDIR}/new.xml
    
    #echo "<content:encoded> <![CDATA[<object width=\"500\" height=\"500\">" >> ${WORKDIR}/new.xml
    #echo "<param name=\"movie\" value=\"${URL}/movies/${TIMESTAMP}.mov\">" >> ${WORKDIR}/new.xml
    #echo "</param>" >> ${WORKDIR}/new.xml
    #echo "<param name=\"autoplay\" value=\"false\">" >> ${WORKDIR}/new.xml
    #echo "</param>" >> ${WORKDIR}/new.xml
    #echo "<embed src=\"${URL}/movies/${TIMESTAMP}.mov\" type=\"application/quicktime\" wmode=\"transparent\" width=\"500\" height=\"500\">" >> ${WORKDIR}/new.xml
    #echo "</embed>" >> ${WORKDIR}/new.xml
    #echo "</object>" >> ${WORKDIR}/new.xml
    #echo "<noembed>" >> ${WORKDIR}/new.xml
    #echo "<a href=\"${URL}/movies/${TIMESTAMP}.mov\">Watch the movie...</a>" >> ${WORKDIR}/new.xml
    #echo "</noembed>]] </content:encoded>" >> ${WORKDIR}/new.xml
   
    echo "<guid>${URL}/movies/${TIMESTAMP}.mov</guid>" >> ${WORKDIR}/new.xml 
    echo "<author>${EMAIL}</author>" >> ${WORKDIR}/new.xml
    echo "<pubDate>${DCSTAMP} ${TZ}</pubDate>" >> ${WORKDIR}/new.xml
    echo "</item>"  >> ${WORKDIR}/new.xml
}
CLEAN_XML_WRITE(){ 
#clean up and make the old feed the new feed etc
    /bin/rm -f ${WORKDIR}/${TIMESTAMP}.title
    # now we take the new and the old and make a new old.
    /bin/mv ${WORKDIR}/old.xml ${WORKDIR}/temp.xml
    /bin/cat ${WORKDIR}/new.xml ${WORKDIR}/temp.xml > ${WORKDIR}/old.xml
    /bin/rm ${WORKDIR}/temp.xml
    /bin/rm ${WORKDIR}/new.xml
    /bin/rm ${WORKDIR}/feed.xml
    XML_Header >> ${WORKDIR}/feed.xml
    /bin/cat ${WORKDIR}/old.xml >> ${WORKDIR}/feed.xml
    #close out the xml
    #echo "<atom:link href=\"${URL}/feed.xml\" rel=\"self\" type=\"application/rss+xml\">"
    echo "</channel>" >> ${WORKDIR}/feed.xml
    echo "</rss>" >> ${WORKDIR}/feed.xml
    # done
    exit 0 
}

#Now make it all do work
cd ${WORKDIR}
# Spam the message on standard input into a scratch file. Pull out the subject header field, then explode the message into its various parts.
cat > ${TEMPFILE}
SUBJECT=`grep -i \^subject: ${TEMPFILE} | cut -c 10-100`
${MUNPACK} -q < ${TEMPFILE} > /dev/null 2> /dev/null
echo $SUBJECT > ${WORKDIR}/${TIMESTAMP}.title
rm -f ${TEMPFILE} 
if [ -f ${WORKDIR}/photo.JPG ]; then
    JPG_OUTPUT
    XML_IMAGE
else
    MOV_OUTPUT
    XML_MOVIE
fi
CLEAN_XML_WRITE
