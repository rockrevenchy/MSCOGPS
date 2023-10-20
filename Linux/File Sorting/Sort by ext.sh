#!/bin/bash
#this script sorts files according to their extensions
oldIFS=$IFS
IFS=$'\n'
(find . -maxdepth 1 -type f) > /tmp/temp
for var in `cat /tmp/temp`
    do
        name=`basename "$var"`
        ext=`echo $name | cut -d'.' -f2- | cut -d'.' -f2- | cut -d'.' -f2- | cut -d'.' -f2- | cut -d'.' -f2- | cut -d'.' -f2- | cut -d'.' -f2-`
        echo $ext
        if [ $ext != sh ] 
            then 
                    mkdir -p !~$ext
                    mv "$var" "!~$ext"/ 2> /dev/null                   
        fi
    done
IFS=$oldIFS
