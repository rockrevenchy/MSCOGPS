#!/bin/bash

echo "looking for current permissions"
# Check if the script is running as root
if [[ $EUID -eq 0 ]]; then
  echo "This script is already running as root."
  # Your script code goes here
  echo "Running with root privileges..."
else
  # Prompt the user for their password
  echo -n "Please enter your password: "
  read -s password
  echo
  
  # Run the command as root using sudo
  echo $password | sudo -S $0 "$@"
  exit
fi
