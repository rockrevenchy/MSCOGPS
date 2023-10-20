#!/bin/bash

# Get the current directory
DIR="."

# Loop through all files in the directory
for file in $DIR/*; do
  # Check if the file is a regular file (not a directory or a symlink) and not a .sh file
  if [ -f "$file" ] && [ "${file##*.}" != "sh" ]; then
    # Get the file's timestamp in (hour.minute.second) day-month-year format
    timestamp=$(date -r "$file" "+%Y-%m-%d (%H.%M.%S)")
    # Get the file's extension
    extension="${file##*.}"
    # Create the new file name with a counter if the file already exists
    new_name="$timestamp.$extension"
    counter=1
    while [ -e "$new_name" ]; do
      new_name="$timestamp--$counter.$extension"
      ((counter++))
    done
    # Rename the file
    mv "$file" "$new_name"
  fi
done

