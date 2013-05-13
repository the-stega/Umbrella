#!/bin/sh

DO_FILE() {
    FILETYPE=`/usr/bin/file -bi ${LARGEFILE}`
    case $FILETYPE in
        image/jpeg )
            JPG_OUTPUT
            MODE=image
            ;;
         video/3gpp )
            MOV_SUFF=3gp
            MOV_OUTPUT
            MODE=movie 
            ;;
         video/quicktime )
            MOV_SUFF=mov
            MOV_OUTPUT
            MODE=movie 
            ;;
          * )
            echo "I have no idea what this is."  
            LARGEFILE=${WORKDIR}/scratch/placeholder.jpg
            SUBJECT=`cat ${WORKDIR}/placeholder.txt`
            JPG_OUTPUT
            MODE=image
            ;;
    esac
}

JPG_OUTPUT() { 
#subroutine for manipulating inbound images. 
#This routine relies upon Image-Magick and replaces the use of JPEGTRAN/EXIFProbe 
    /bin/cp ${LARGEFILE} photoX1X.jpg 2> /dev/null
    # Otherwise it's going to use the nice new image
    chmod 744 photoX1X.jpg
    
    $IMAGEMAGICK/convert photoX1X.jpg -auto-orient -resize ${VSIZE} photoX1X.jpg
    $IMAGEMAGICK/composite -dissolve 50% -gravity south -quality 100 \( ${WATERMARK} -resize 50% \) photoX1X.jpg photoX1X.jpg
    
    esac
    #
    # Larger images must be scaled with Umbrella, as manipulating them in the RSS code is very problematic.
    

# In addition to saving it to a permanent file named by the timestamp, it will also copy it to the current top image This is handy if you want to have a splash page that just links to the most current image
    cp photoX1X.jpg ${WORKDIR}/current-mblog.jpg
    chmod 755 current-mblog.jpg 
    mv photoX1X.jpg ${WORKDIR}/images/${TIMESTAMP}.jpg
  
    OUTPUT_FILE=${TIMESTAMP}.jpg
}

MOV_OUTPUT(){ 
# subroutine to manipulate the inbound movie file.
     
     /bin/cp ${LARGEFILE} ${WORKDIR}/movies/${TIMESTAMP}.${MOV_SUFF} 2> /dev/null   
     chmod 744 ${WORKDIR}/movies/${TIMESTAMP}.${MOV_SUFF}
     OUTPUT_FILE=${TIMESTAMP}.${MOV_SUFF}
}

#JPG_OUTPUT_JTRAN() { 
#subroutine for manipulating inbound images.  This is how it used to be done.
#    /bin/cp ${LARGEFILE} photoX1X.jpg 2> /dev/null
    # Otherwise it's going to use the nice new image
#    chmod 744 photoX1X.jpg
    # Due to changes in how iPhones save images, we now need to pull out the Orientation from the EXIF data.  
    #This is not needed for other phone types
    #
#    ORIENTATION=`$IMAGEMAGICK/identify -L photoX1X.jpg | grep Orientation | cut -d = -f 2`
    # The EXIF options from an iPhone photo are 1, 3, 6 or 8
#    case $ORIENTATION in
#        " 1 " )
    # camera was at the top left (landscape) so no transform needed
#            ;;
#        " 3 " )
    # camera was at the bottom right (portrait) so need to rotate
#            mv photoX1X.jpg old-photoX1X.jpg
#            ${JPEGTRAN} -trim -rotate 180 old-photoX1X.jpg > photoX1X.jpg
#            rm old-photoX1X.jpg
#            ;;
#        " 6 " )
    # camera was at the right top (portrait) so need to rotate
#            mv photoX1X.jpg old-photoX1X.jpg
#            ${JPEGTRAN} -trim -rotate 90 old-photoX1X.jpg > photoX1X.jpg
#            rm old-photoX1X.jpg 
#            ;;
#        " 8 " )
    # camera was at the bottom left (landscape) so need to rotate
#            mv photoX1X.jpg old-photoX1X.jpg
#            ${JPEGTRAN} -trim -rotate 270 old-photoX1X.jpg > photoX1X.jpg
#            rm old-photoX1X.jpg
#            ;;
#    esac
    #
   # Larger images must be scaled with Umbrella, as manipulating them in the RSS code is very problematic. 
   #This was never implemented.
   # HSIZE=`$EXIFPROBE -L photoX1X.jpg | grep PixelXDimension | cut -d = -f 4`
   # YSIZE=`$EXIFPROBE -L photoX1X.jpg | grep PixelYDimension | cut -d = -f 4`
   # if ${HSIZE} > 600
   #     then
   #     ${JPEGTRAN}

# In addition to saving it to a permanent file named by the timestamp, it will also copy it to the current top image This is handy if you want to have a splash page that just links to the most current image
#    cp photoX1X.jpg ${WORKDIR}/current-mblog.jpg
#    chmod 755 current-mblog.jpg 
#    mv photoX1X.jpg ${WORKDIR}/images/${TIMESTAMP}.jpg
#  
#    OUTPUT_FILE=${TIMESTAMP}.jpg
#}