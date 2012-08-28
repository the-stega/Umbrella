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
WEB="/home/www/Sites/stega.org/htdocs/Umbrella"
USER="stega"
GROUP="staff"
cp www/* $WEB/
chown $USER:$GROUP $WEB/*
