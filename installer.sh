#!/bin/sh
#
# Umbrella 3.0 smart phone to RSS
# Take a picture or video with your phone and post it to your private (non-cloud) photo/vid blog
# Copyright 2004, 2007, 2011, 2012 by stega:  stega@stega.org
# installer script
#
# Set Variables
# 
# Location for www files
. umbrella/variables
WEB=$WORKDIR
mkdir ${WEB}
cp www/placeholder.jpg ${WEB}/
cp www/placeholder.txt ${WEB}/
cp www/style.css ${WEB}/
touch ${WEB}/feed.xml
touch ${WEB}/old.xml
tar -xf dev/magpierss-0.72.tar 
mv magpierss-0.72 ${WEB}/

(cd ${WEB} && ln -s magpierss-0.72 magpierss)

cat www/index.php | sed -e "s/HOWMANY/${HOW_MANY}/" -e "s/URL_REPLACE/${URL}/" -e "s/STYLESHEET_REPLACE/${STYLE}/" > ${WEB}/index.php
