#!/bin/bash

# Set the directory you want to sort
DIR="."

# Loop through files in the directory
for file in "$DIR"/*; do
    # Check if the file is a regular file and is not a .sh file
    if [[ -f "$file" ]] && [[ ! "$file" =~ \.sh$ ]]; then
        # Get the year of creation for the file
        year=$(date -r "$file" +"%Y")
        # Create a new folder for the year if it doesn't already exist
        if [ ! -d "$DIR/$year" ]; then
            mkdir -p "$DIR/$year"
            echo "Created directory $DIR/$year"
        fi
        # Move the file to the new folder
        mv "$file" "$DIR/$year"
        echo "Moved file $file to directory $DIR/$year"
    fi
done

# Loop through subfolders by year
for yearfolder in "$DIR"/*/; do
    # Sort files by creation time and move them to the year folder
    find "$yearfolder" -maxdepth 0 -type f -printf '%T@ %p\n' | sort -n | cut -d ' ' -f 2- | xargs -I{} mv {} "$yearfolder"
    echo "Sorted files in directory $yearfolder"
done

