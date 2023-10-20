#!/bin/bash

# Check if kdialog is installed
if ! command -v kdialog &> /dev/null; then
    echo "kdialog is not installed. Please install it."
    exit 1
fi

# Request sudo password in a graphical pop-up
password=$(kdialog --password "Enter your sudo password:")

# Check if the password is empty (user canceled)
if [ -z "$password" ]; then
    kdialog --error "Password not entered. Exiting."
    exit 1
fi

# Use the obtained password to execute a command
echo "$password" | sudo -S grub-reboot "$(grep -i windows /boot/grub/grub.cfg|cut -d"'" -f2)"
kdialog --msgbox "Restarting to Windows very shortly"
reboot
