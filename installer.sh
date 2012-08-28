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
mkdir $WEB
cp www/index.php $WEB/
cp www/placeholder.jpg $WEB/
cp www/placeholder.txt $WEB/
cp www/style.css $WEB/
touch $WEB/feed.xml
touch $WEB/old.xml
tar -xvf dev/magpierss-0.72.tar $WEB
ln -s $WEB/magpierss-0.72 $WEB/magpierss
