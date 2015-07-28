#!/bin/bash

# Backup your pictures
# By Juan C. Riano

# This script backups your JPG or JPEG pictures organizing them into folders by year and month.
# Folders are created only if they do not already exist.

# Dependencies: grep, awk, exif.

# Destination folder.
PICSDESTINATION='/media/juan/T2/Familia-Riano-Fotos/'


# Source Folder
#PICSSOURCE=~/Dropbox/picsluisa/camera
PICSSOURCE=~/Dropbox/pics

for file in $( ls $PICSSOURCE/*.{jpg,JPG,JPEG,jpeg} )
do 
	echo "Backing up $file"
	WHOLESTR=$( exif $file | grep 'Date and Time' | grep 'Origi' )
	THEDATE=$( echo "$WHOLESTR" | awk '{split($0,arr,"|"); print arr[2]}' )
	THEYEAR=$( echo "$THEDATE" | awk '{split($0,arr,":"); print arr[1]}' )
	THEMONTH=$( echo "$THEDATE" | awk '{split($0,arr,":"); print arr[2]}' )

	if [[ "$THEYEAR" == "" ]]	# Is there exif info for this picture?
	then
		THEFOLDER="$PICSDESTINATION/no-date"	# Pictures with no exif info.
	else 
		THEFOLDER="$PICSDESTINATION/$THEYEAR-$THEMONTH"	# Folder in format yyyy-mm
	fi
	
	# Create folder, ignore if folder already exists.
	$( mkdir -p "$THEFOLDER")

	# Copy files, change for mv if you want to delete original files.
	cp "$file" "$THEFOLDER"
done
echo "Completed backing up pictures."
