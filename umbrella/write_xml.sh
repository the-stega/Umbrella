XML_Header() {
# subroutine to build the xml header

    echo "<rss version=\"2.0\">" >> ${WORKDIR}/feed.xml
    echo "<channel>" >> ${WORKDIR}/feed.xml
    echo "<title>Stega mBlog</title>" >> ${WORKDIR}/feed.xml
    echo "<link>${URL}</link>" >> ${WORKDIR}/feed.xml
    echo "<description>Things captured by a little phone</description>" >> ${WORKDIR}/feed.xml
    echo "<language>en-us</language>" >> ${WORKDIR}/feed.xml 
    echo "<lastBuildDate>${DCSTAMP} ${TZ}</lastBuildDate>"  >> ${WORKDIR}/feed.xml
    echo "<generator>Umbrella 2.0</generator>" >> ${WORKDIR}/feed.xml
    echo "<managingEditor>${EMAIL}</managingEditor>" >> ${WORKDIR}/feed.xml
    echo "<copyright>${COPYRIGHT}</copyright>" >> ${WORKDIR}/feed.xml
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
    #
    # Set the LINK Variable.  This is used later to provide a trackback.
    LINK="${URL}/images/${TIMESTAMP}.jpg"
}

#
# subroutine to build xml for movies
#
XML_MOVIE(){ 
    echo "<item>" >> ${WORKDIR}/new.xml
    echo "<title>${TITLESTAMP}" `/bin/cat ${WORKDIR}/${TIMESTAMP}.title` "</title>" >>  ${WORKDIR}/new.xml
    echo "<link>${URL}/index.php</link>" >> ${WORKDIR}/new.xml
    echo "<description>" >> ${WORKDIR}/new.xml
    echo "<![CDATA[ <object width=\"500\" height=\"500\">" >> ${WORKDIR}/new.xml
    echo "<param name=\"movie\" value=\"${URL}/movies/${TIMESTAMP}.${MOV_SUFF}\">" >> ${WORKDIR}/new.xml 
    echo "</param>" >> ${WORKDIR}/new.xml
    echo "<param name=\"autoplay\" value=\"false\">" >> ${WORKDIR}/new.xml
    echo "</param>" >> ${WORKDIR}/new.xml
    echo "<embed src=\"${URL}/movies/${TIMESTAMP}.${MOV_SUFF}\" type=\"application/quicktime\" wmode=\"transparent\" width=\"500\" height=\"500\">" >> ${WORKDIR}/new.xml
    echo "</embed>" >> ${WORKDIR}/new.xml
    echo "</object>" >> ${WORKDIR}/new.xml
    echo "<noembed>" >> ${WORKDIR}/new.xml
    echo "<a href=\"${URL}/movies/${TIMESTAMP}.${MOV_SUFF}\">Watch the movie...</a>" >> ${WORKDIR}/new.xml
    echo "</noembed>]]>" >> ${WORKDIR}/new.xml
    echo "</description>" >> ${WORKDIR}/new.xml
    echo "<guid>${URL}/movies/${TIMESTAMP}.${MOV_SUFF}</guid>" >> ${WORKDIR}/new.xml 
    echo "<author>${EMAIL}</author>" >> ${WORKDIR}/new.xml
    echo "<pubDate>${DCSTAMP} ${TZ}</pubDate>" >> ${WORKDIR}/new.xml
    echo "</item>"  >> ${WORKDIR}/new.xml
    #
    # Set the LINK Variable.  This is used later to provide a trackback.
    LINK="${URL}/images/${TIMESTAMP}.jpg"
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
    echo "</channel>" >> ${WORKDIR}/feed.xml
    echo "</rss>" >> ${WORKDIR}/feed.xml
    # done
}
