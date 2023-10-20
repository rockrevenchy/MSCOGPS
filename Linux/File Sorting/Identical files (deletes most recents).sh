#!/bin/bash

# The directory to search for identical files
dir="."

# Create an associative array to store the file hashes and timestamps
declare -A hashes
declare -A timestamps

# Loop through all the files in the directory and its subdirectories
while read -r file; do
  # Calculate the MD5 hash of the file
  hash=$(md5sum "$file" | awk '{print $1}')

  # Check if the hash already exists in the array
  if [[ -n "${hashes[$hash]}" ]]; then
    echo "Identical files found: $file ${hashes[$hash]}"

    # Determine which file is the most recent
    if [[ "${timestamps[$hash]}" -lt "$(stat -c %Y "$file")" ]]; then
      rm "${hashes[$hash]}"
      echo "Deleted ${hashes[$hash]}"
      # Update the hash and timestamp for the remaining file
      hashes[$hash]="$file"
      timestamps[$hash]=$(stat -c %Y "$file")
    else
      rm "$file"
      echo "Deleted $file"
    fi

    # Output the names of the identical files to a log file
    # echo "Identical files found: $file ${hashes[$hash]}" >> identical_files.log
  else
    # Add the hash and timestamp to the arrays
    hashes[$hash]="$file"
    timestamps[$hash]=$(stat -c %Y "$file")
  fi
done < <(find "$dir" -type f)

# Print a message indicating the script has finished
echo "Identical files search complete"
sleep 3

