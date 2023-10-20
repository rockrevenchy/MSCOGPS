#!/bin/bash

YOURID=65268126
LCVDFO="$HOME/.steam/steam/userdata/$YOURID/config/localconfig.vdf"
LCVDF="/tmp/localconfig.vdf"

LOPT="\\\t\t\t\t\t\t\"LaunchOptions\"		\"gamemoderun mangohud %command%\""

if [ $YOURID -eq 0 ]; then
	echo "you have to edit YOURID first, to match the directory name of your steamID - exit"
	echo "maybe:"
	ls -1 "$HOME/.steam/steam/userdata/"
	exit 1
fi

if [ ! -f $LCVDF ]; then
	echo "$LCVDF doesn't exist - copying the original"
	if [ ! -f $LCVDFO ]; then
		echo "$LCVDFO doesn't exist as well - giving up"
		exit 1
	else
	cp $LCVDFO $LCVDF
	fi
fi

sed -i '/LaunchOptions/d' $LCVDF
sed -i '/"Playtime"/i '"$LOPT"'' $LCVDF

echo "done - you might want to check if the file $LCVDF looks valid before using it!"
echo "make sure to close steam before copying the file!"
echo "cp $LCVDFO $LCVDFO.bak"
echo "cp $LCVDF $LCVDFO"

