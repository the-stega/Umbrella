#!/bin/sh
#
# Umbrella 3.0 smart phone to RSS
# Take a picture or video with your phone and post it to your private (non-cloud) photo/vid blog
# Copyright 2004, 2007, 2011, 2012 by stega:  stega@stega.org
# installer script
#
# Set Variables
. umbrella/variables.txt
# 
#
#Check to see if WORKDIR already exists and ask if it should be removed
if [ -d "$WORKDIR" ]
then
#	echo "WORKDIR already present.  Please remove it and try again."
	echo "WORKDIR already present.  Should it be overwritten? (y or n)"
#   printf 
	read ans
	if [ "$ans" = "y" ]
	then 
		rm -rf ${WORKDIR}
	else
		echo "You selected no, so I will now exit."
		exit	
	fi	
else [
	]
fi	

# Check variables for changes
if [ ${WORKDIR}x = "/FULLPATH_TO_SITE/Umbrella"x ]
then 
	echo "WORKDIR is not set to an actual directory"
	exit 1
fi
case ${PHONE} in 
	"iphone" | "blackberry" | "android" | "other" )
		;;
	* )
		echo "PHONE value is not set to something useful."	
		exit 1
		;;
esac
# 
# Location for www files
WEB=$WORKDIR
#
# Do the install tasks
mkdir ${WEB}
cp www/placeholder.jpg ${WEB}/
cp www/placeholder.txt ${WEB}/
cp www/style.css ${WEB}/
touch ${WEB}/feed.xml
touch ${WEB}/old.xml
tar -xf dev/magpierss-0.72.tar 
mv magpierss-0.72 ${WEB}/
(cd ${WEB} && ln -s magpierss-0.72 magpierss)
(cd ${WEB} && mkdir images)
(cd ${WEB} && mkdir movies)
echo "I have put all the appropriate files in your WORKDIR location"
cat www/index.php | sed -e "s%HOW_MANY%${HOW_MANY}%" -e "s%URL_REPLACE%${URL}%" -e "s%STYLESHEET_REPLACE%${STYLE}%" > ${WEB}/index.php
echo "I have set the values for index.php and placed it in your WORKDIR"
#
# Now run the test cases to be sure the basics are working (will fail if iphone is not the selected type--will add additional test cases for release)
case ${PHONE} in 
	"iphone" )
		(cd umbrella && sh umbrella.sh < ../samples/iphone/iphone-landscape-image-02-medium.eml)
		sleep 1
		(cd umbrella && sh umbrella.sh < ../samples/iphone/iphone-portrait-image-02-medium.eml)
		sleep 1
		(cd umbrella && sh umbrella.sh < ../samples/iphone/iphone-portrait-vid.eml) 
		sleep 1
		echo "I have successfully run the iPhone test cases. You should be able to view WORKDIR/index.php from a web browser"
		;;	
	* )
	"andoid" )
		
		echo "Done with install"
		;;	
	* )		
esac
echo "Please run your own samples through now"
