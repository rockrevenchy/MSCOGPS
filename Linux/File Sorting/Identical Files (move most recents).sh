#!/bin/bash

# The directory to search for identical files
dir="."

# Create an associative array to store the file hashes and timestamps
declare -A hashes
declare -A timestamps

# Create the ".Identical_Files" directory if it doesn't exist
mkdir -p "$dir/.Identical_Files"

# Loop through all the files in the directory and its subdirectories
while read -r file; do
  # Calculate the MD5 hash of the file
  hash=$(md5sum "$file" | awk '{print $1}')

  # Check if the hash already exists in the array
  if [[ -n "${hashes[$hash]}" ]]; then
    echo "Identical files found: $file ${hashes[$hash]}"
    echo "Identical files found: $file ${hashes[$hash]}">>./.Identical_Files/.Identical_Files.log
    # Determine which file is the most recent
    if [[ "${timestamps[$hash]}" -lt "$(stat -c %Y "$file")" ]]; then
      mv "${hashes[$hash]}" "$dir/.Identical_Files/"
      echo "Moved ${hashes[$hash]} to $dir/.Identical_Files/"
      echo "Moved ${hashes[$hash]} to $dir/.Identical_Files/">>./.Identical_Files/.Identical_Files_moved.log
      # Update the hash and timestamp for the remaining file
      hashes[$hash]="$file"
      timestamps[$hash]=$(stat -c %Y "$file")
    else
      mv "$file" "$dir/.Identical_Files/"
      echo "Moved $file to $dir/.Identical_Files/"
      echo "Moved $file to $dir/.Identical_Files/">>./.Identical_Files/.Identical_Files_moved.log
    fi
  else
    # Add the hash and timestamp to the arrays
    hashes[$hash]="$file"
    timestamps[$hash]=$(stat -c %Y "$file")
  fi
done < <(find "$dir" -type f)

# Print a message indicating the script has finished
echo "Identical files search complete"
sleep 3

