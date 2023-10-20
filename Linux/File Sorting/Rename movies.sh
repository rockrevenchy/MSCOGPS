#!/bin/bash

echo This script relies on exiftool, if in doubt, install it with
echo sudo apt install libimage-exiftool-perl
echo  
echo starting script
echo  

# Directory containing your movie files
movie_dir=$(pwd)

# List of supported video file extensions
supported_extensions=("mp4" "m4a" "mkv" "mov")

# Loop through all supported video files in the directory
for ext in "${supported_extensions[@]}"; do
    for file in "$movie_dir"/*."$ext"; do
        if [ -f "$file" ]; then
            # Use exiftool to extract title and year metadata
            title=$(exiftool -s -s -s -Title "$file")
            year=$(exiftool -s -s -s -ContentCreateDate "$file")

            # Ensure the title is non-empty
            if [ -n "$title" ]; then
                # Construct the new filename with or without the year
                if [ -n "$year" ]; then
                    new_filename="$title [$year].$ext"
                else
                    new_filename="$title.$ext"
                fi

                # Rename the file
                mv "$file" "$movie_dir/$new_filename"
                echo "Renamed: $file -> $new_filename"
                echo   
            else
            	echo !!!!!!!!
                echo "Skipping $file due to missing title metadata"
                echo !!!!!!!!
                echo   
            fi
        fi
    done
done

echo "Script completed"
sleep 5
