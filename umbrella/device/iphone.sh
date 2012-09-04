#!/bin/sh
#iPhone support

DO_FILE() {
    if [ -f ${SCRATCH_DIR}/photo.JPG ]; then
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
    /bin/cp ${SCRATCH_DIR}/photo.JPG ${SCRATCH_DIR}/photoX1X.jpg 2> /dev/null
    # If something is broken: it will use the placeholder image.
    if [ ! -f ${SCRATCH_DIR}/photoX1X.jpg ]
    then
	   cp ${SCRATCH_DIR}/placeholder.jpg ${SCRATCH_DIR}/photoX1X.jpg;
    fi
    # Otherwise it's going to use the nice new image
    chmod 744 ${SCRATCH_DIR}/photoX1X.jpg

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
    cp ${SCRATCH_DIR}/photoX1X.jpg ${SCRATCH_DIR}/current-mblog.jpg
    chmod 755 ${SCRATCH_DIR}/current-mblog.jpg 
    mv ${SCRATCH_DIR}/photoX1X.jpg ${WORKDIR}/images/${UNQID}.jpg
    /bin/rm ${SCRATCH_DIR}/photo* 2> /dev/null

    OUTPUT_FILE=${UNQID}.jpg
}

MOV_OUTPUT(){ 
# subroutine to manipulate the inbound movie file.
    /bin/cp ${SCRATCH_DIR}/IMG_*.MOV ${SCRATCH_DIR}/IMGMOV_X1X.mov 2> /dev/null
    # If something is broken: it will use the placeholder image.
    if [ ! -f ${SCRATCH_DIR}/IMGMOV_X1X.mov ]
    then
        cp ${SCRATCH_DIR}/placeholder.jpg ${SCRATCH_DIR}/IMGMOV_X1X.mov
    fi
    # Otherwise it is going to use the nice new movie  
    chmod 744 ${SCRATCH_DIR}/IMGMOV_X1X.mov
    mv ${SCRATCH_DIR}/IMGMOV_X1X.mov ${WORKDIR}/movies/${UNQID}.mov
    /bin/rm ${SCRATCH_DIR}/IMG* 2> /dev/null

    OUTPUT_FILE=${UNQID}.mov
}