#!/bin/sh
#iPhone support

DO_FILE() {
    if [ -f ${WORKDIR}/photo.JPG ]; then
        JPG_OUTPUT
        MODE=image
    else
        MOV_OUTPUT
        MODE=movie
    fi
}

JPG_OUTPUT() { 
#subroutine for manipulating inbound images
    # The name and format of the imagesge may vary.  
    /bin/cp ${WORKDIR}/photo.JPG ${WORKDIR}/photoX1X.jpg 2> /dev/null
    # If something is broken: it will use the placeholder image.
    if [ ! -f ${WORKDIR}/photoX1X.jpg ]; then
	   cp ${WORKDIR}/placeholder.jpg ${WORKDIR}/photoX1X.jpg;
    fi
    # Otherwise it's going to use the nice new image
    chmod 744 ${WORKDIR}/photoX1X.jpg

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
    cp ${WORKDIR}/photoX1X.jpg ${WORKDIR}/current-mblog.jpg
    chmod 755 ${WORKDIR}/current-mblog.jpg 
    mv ${WORKDIR}/photoX1X.jpg ${WORKDIR}/images/${TIMESTAMP}.jpg
    /bin/rm ${WORKDIR}/photo* 2> /dev/null

    OUTPUT_FILE=${TIMESTAMP}.jpg
}

MOV_OUTPUT(){ 
# subroutine to manipulate the inbound movie file.
    /bin/cp ${WORKDIR}/IMG_*.MOV ${WORKDIR}/IMGMOV_X1X.mov 2> /dev/null
    # If something is broken: it will use the placeholder image.
    if [ ! -f ${WORKDIR}/IMGMOV_X1X.mov ] then
        cp ${WORKDIR}/placeholder.jpg ${WORKDIR}/IMGMOV_X1X.mov
    fi
    # Otherwise it is going to use the nice new movie  
    chmod 744 ${WORKDIR}/IMGMOV_X1X.mov
    mv ${WORKDIR}/IMGMOV_X1X.mov ${WORKDIR}/movies/${TIMESTAMP}.mov
    /bin/rm ${WORKDIR}/IMG* 2> /dev/null

    OUTPUT_FILE=${TIMESTAMP}.mov
}