#!/bin/bash

#Think of this script as a cheaper version of Symmantec Norton Ghost
#Works especially well with managing multiple USB keys or to copy a drive

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (with sudo)."
  exit
fi
clear
echo "Available Disks:"
lsblk -o NAME,SIZE,TYPE,MOUNTPOINT

echo -e "\nWelcome to Disk Imager Script"
echo "---------------------------------"

PS3="Select an operation: "

options=("Save Drive As Image" "Deploy Image To Drive" "Copy Drive to Drive" "Quit")

select opt in "${options[@]}"
do
    case $opt in
        "Save Drive As Image")
            echo "Enter source drive (e.g., sdd): "
            read source_drive
            source_drive="/dev/$source_drive"
            echo "Enter destination of the image file path (e.g., /path/to/backup.img): "
            echo "(for a compressed image, put '.img.gz' as the file ext)"
            echo "(for a uncompressed image, put '.img' as the file ext)"
            read destination_image
            echo "Are you sure you want to proceed? (y/n): "
            read confirm
            if [ "$confirm" == "y" ]; then
                dd if=$source_drive bs=4M status=progress | gzip > $destination_image
                echo "Disk Image completed!"
                break
            else
                echo "Operation canceled."
            fi
            break
            ;;
        "Deploy Image To Drive")
            echo "Enter source image file path (e.g., /path/to/backup.img or /path/to/backup.img.gz): "
            read source_image
            echo "Enter destination drive (e.g., sdd): "
            read destination_drive
            destination_drive="/dev/$destination_drive"
            echo "Everything on "$destination_drive" will be DELETED. "
            echo "Are you sure you want to proceed? (y/n): "
            read confirm
            if [ "$confirm" == "y" ]; then
                # Check file extension
                if [[ "$source_image" == *.gz ]]; then
                    # Compressed image
                    gunzip -c $source_image | dd of=$destination_drive bs=4M status=progress
                else
                    # Uncompressed image
                    dd if=$source_image of=$destination_drive bs=4M status=progress
                fi

                # Check and resize filesystem if it's ext2/ext3/ext4
                filesystem_type=$(lsblk -no FSTYPE $destination_drive)
                if [ "$filesystem_type" == "ext2" ] || [ "$filesystem_type" == "ext3" ] || [ "$filesystem_type" == "ext4" ]; then
                    resize2fs $destination_drive
                else
                    echo "Filesystem type is not ext2/ext3/ext4. Resize not possible. Skipping."
                fi

                echo "Deployment completed!"
                break
            else
                echo "Operation canceled."
            fi
            break
            ;;
        "Copy Drive to Drive")
            echo "Enter source drive (e.g., sdd): "
            read source_drive
            echo "Enter destination drive (e.g., sde): "
            read destination_drive
            source_drive="/dev/$source_drive"
            destination_drive="/dev/$destination_drive"
            echo "Everything on "$destination_drive" will be DELETED. "
            echo "Are you sure you want to proceed? (y/n): "
            read confirm
            if [ "$confirm" == "y" ]; then
                dd if=$source_drive of=$destination_drive bs=4M status=progress

                # Check and resize filesystem if it's ext2/ext3/ext4
                filesystem_type=$(lsblk -no FSTYPE $destination_drive)
                if [ "$filesystem_type" == "ext2" ] || [ "$filesystem_type" == "ext3" ] || [ "$filesystem_type" == "ext4" ]; then
                    resize2fs $destination_drive
                else
                    echo "Filesystem type is not ext2/ext3/ext4. Resize not possible. Skipping."
                fi

                echo "Drive copy completed!"
                break
            else
                echo "Operation canceled."
            fi
            break
            ;;
        "Quit")
            echo "Exiting script."
            break
            ;;
        *)
            echo "Invalid option. Please choose a valid operation."
            ;;
    esac
done
