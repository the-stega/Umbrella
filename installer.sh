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
echo 'web='$WEB
mkdir $WEB
echo 'I have made the web directory'
cp www/placeholder.jpg $WEB/
cp www/placeholder.txt $WEB/
cp www/style.css $WEB/
echo 'I have copied the files'
touch $WEB/feed.xml
touch $WEB/old.xml
echo 'I have touched feed and old'
tar -xf dev/magpierss-0.72.tar 
echo 'I have untard magpierss'
mv magpierss-0.72 $WEB/
echo 'I have moved magpierss'
ln -s $WEB/magpierss-0.72 $WEB/magpierss
echo 'I have made the symlink'

cat www/index.php | sed -e 's/HOWMANY/${HOW_MANY}/' 's/URL_REPLACE/${URL}/' 's/STYLESHEET_REPLACE/${STYLE}/' > www/new_index.php

mv www/new_index.php $WEB/index.php