#!/bin/bash

# The directory to search for identical files
dir="."

# Create an associative array to store the file hashes
declare -A hashes

# Loop through all the files in the directory and its subdirectories
while read -r file; do
  # Calculate the MD5 hash of the file
  hash=$(md5sum "$file" | awk '{print $1}')

  # Check if the hash already exists in the array
  if [[ -n "${hashes[$hash]}" ]]; then
    echo "Identical files found: $file ${hashes[$hash]}"
    # Prompt the user to choose whether to delete one of the files or ignore it
    choice=""
    while [[ ! "$choice" =~ ^(y|Y|n|N)$ ]]; do
      read -p "Do you want to delete one of the files? (y/n): " choice < /dev/tty
    done

    case "$choice" in
      [Yy]* )
        # Prompt the user to choose which file to delete
        file_choice=""
        while [[ ! "$file_choice" =~ ^(1|2)$ ]]; do
          read -p "Which file do you want to keep? Enter '1' or '2': " file_choice < /dev/tty
        done

        if [[ $file_choice -eq 1 ]]; then
          rm "${hashes[$hash]}"
          echo "Deleted ${hashes[$hash]}"
        elif [[ $file_choice -eq 2 ]]; then
          rm "$file"
          echo "Deleted $file"
        fi
        ;;
      [Nn]* )
        # Ignore the identical files and move on
        echo "Identical files ignored."
        ;;
      * )
        echo "Invalid choice. Please enter 'y' or 'n'."
        ;;
    esac

    # Output the names of the identical files to a log file
    # echo "Identical files found: $file ${hashes[$hash]}" >> identical_files.log
  else
    # Add the hash to the array
    hashes[$hash]="$file"
  fi
done < <(find "$dir" -type f)

# Print a message indicating the script has finished
echo "Identical files search complete"
sleep 3

