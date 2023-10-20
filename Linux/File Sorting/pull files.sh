#!/bin/bash

read -p "Are you sure you want to move all files to the current directory and delete empty directories? Type 'yes' to confirm: " confirm

if [ "$confirm" = "yes" ]; then
  # Move all files to the current directory and list them
  echo "Moving files..."
  moved_files=$(find . -mindepth 2 -type f -print0 | xargs -0 mv -t .)
  echo "The following files were moved:"
  echo "$moved_files"

  # Delete all empty directories and list them
  echo "Deleting empty directories..."
  deleted_dirs=$(find . -mindepth 1 -depth -type d -empty -print0 | xargs -0 rmdir)
  echo "The following directories were deleted:"
  echo "$deleted_dirs"
  
  echo "Done!"
else
  echo "Aborted."
fi

