#!/bin/bash

# Set the directory you want to sort
DIR="."

# Loop through files in the directory
for file in "$DIR"/*; do
    # Check if the file is a regular file and is not a .sh file
    if [[ -f "$file" ]] && [[ ! "$file" =~ \.sh$ ]]; then
        # Get the month and year of creation for the file
        monthyear=$(date -r "$file" +"%Y-%m")
        # Create a new folder for the month and year if it doesn't already exist
        if [ ! -d "$DIR/$monthyear" ]; then
            mkdir -p "$DIR/$monthyear"
            echo "Created directory $DIR/$monthyear"
        fi
        # Move the file to the new folder
        mv "$file" "$DIR/$monthyear"
        echo "Moved file $file to directory $DIR/$monthyear"
    fi
done

# Loop through subfolders by month and year
for monthyearfolder in "$DIR"/*/; do
    # Sort files by creation time and move them to the month and year folder
    find "$monthyearfolder" -maxdepth 0 -type f -printf '%T@ %p\n' | sort -n | cut -d ' ' -f 2- | xargs -I{} mv {} "$monthyearfolder"
    echo "Sorted files in directory $monthyearfolder"
done

