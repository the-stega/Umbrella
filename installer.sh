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
cat www/index.php | sed -e "s%HOW_MANY%${HOW_MANY}%" -e "s%URL_REPLACE%${URL}%" -e "s%STYLESHEET_REPLACE%${STYLE}%" > ${WEB}/index.php
#
# Now run the test cases to be sure the basics are working (will fail if iphone is not the selected type--will add additional test cases for release)
sh umbrella/umbrella.sh < samples/iphone/iphone-test-01.eml
sh umbrella/umbrella.sh < samples/iphone/iphone-test-02.eml
sh umbrella/umbrella.sh < samples/iphone/iphone-test-vid.eml