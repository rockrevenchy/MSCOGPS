#!/bin/bash
echo "Verifying root permissions..."
sleep 1

#|- Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "This script requires root permissions. Please run it with sudo."
    exit 1
fi
echo "root permissions are valid!"
sleep 1
clear

#-| Installing required tools and radjusting
echo "getting required tools for the script"
sleep 1
apt install xdotool -y
xdotool windowsize $(xdotool getactivewindow) 750 560
tput cols 90
tput lines 28
echo "resized terminal"
sleep 2

#-| Repository lookup
clear
echo "looking for required ppas"
sleep 1

repositories=(
    "https://ppa.launchpadcontent.net/jonaski/strawberry/ubuntu"
    "https://txos-extra.tuxedocomputers.com/ubuntu"
    "http://us.archive.ubuntu.com/ubuntu/"
)

check_repository() {
    local repository_url="$1"

    if grep -q "$repository_url" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        echo "Repository found in system: $repository_url"
        return 0 
    else
        echo "Repository NOT found in system: $repository_url"
        return 1
    fi
}

# Check all repositories
all_repositories_exist=true
for repository in "${repositories[@]}"; do
    if ! check_repository "$repository"; then
        all_repositories_exist=false
    fi
done

# Compare repositories and request action if not detected
if $all_repositories_exist; then
    echo "All repositories detected. Proceeding with the rest of the script..."
    sleep 2
    else
        while true; do
            echo "Not all repositories detected. Some packages could be missing."
            echo "Do you want to add required repositories? (y/n)"
            read answer
        case "$answer" in
            [yY])
                echo "Adding required repositories"
                add-apt-repository https://ppa.launchpadcontent.net/jonaski/strawberry/ubuntu/ -y
                add-apt-repository https://txos-extra.tuxedocomputers.com/ubuntu -y
                add-apt-repository http://us.archive.ubuntu.com/ubuntu/ -y
                echo "done"
                sleep 2
                break
                ;;
            [nN])
                echo "Skipping repository addition..."
                sleep 2
                break
                ;;
            *)
                echo "Invalid input. Please enter 'y' or 'n'."
                ;;
        esac
    done
fi

clear

# Initialize an empty variable to store selected options
selected_options=""

# Function to display the menu
options=("Run & Quit" "earlyoom" "htop" "ne" "npm" "wine" "winetricks" "fonts-symbola" "ttf-mscorefonts-installer" "exe-thumbnailer" "default-jre" "git" "snapd" "flatpak" "neofetch" "timeshift" "firefox" "chromium" "falkon" "remmina" "timeshift" "mangohud" "steam-installer" "lutris" "playonlinux" "protontricks" "python3" "python3-pip" "python3.10-venv" "strawberry" "vlc" "gimp" "kdenlive" "libreoffice" "appimagelauncher" "audacity" "konqueror" "krusader" "gedit" "geany" "filezilla" "xarchiver" "arqiver" "synaptic" "discover" "lxtask" "stacer" "bleachbit" "sweeper" "clamtk" "links" "w3m" "gparted" "virtualbox")

# Maximum number of columns
max_columns=18

# Flag to control the loop
quit_selected=false

# Function to calculate column widths
calculate_column_widths() {
    max_length=24
    for option in "${options[@]}"; do
        length=${#option}
        if (( length > max_length + 4 )); then
            max_length=$length
        fi
    done
    column_width=$((max_length))
}

#|- Function to display the menu
show_menu() {
    clear
    echo "Selected options: $selected_options"
    echo " "
    echo "Select options (re-select to remove from your list)"
    echo "These will be installed as .deb packages via apt:"
    echo "--->>  --->>  --->>  --->>  --->>  --->>  --->>"

    # Calculate column widths
    calculate_column_widths
    
    # Calculate the number of columns
    num_columns=$(( ( ${#options[@]} + max_columns - 1 ) / max_columns ))

    # Display the options in multiple columns
    for ((i = 0; i < ${#options[@]}; i++)); do
        printf "  %-${column_width}s" "$((i + 1)). ${options[i]}"
        if (( (i + 1) % num_columns == 0 )); then
            echo
        fi
    done

    # Prompt the user for input
    echo -e "\nEnter 1 (run & exit) alone to run the currently selected options."
    echo -e "Enter your selection(s) separated by spaces or one at a time:"
    read -p "-" selections

    # Process user input
    for selection in $selections; do
        if [[ "$selection" =~ ^[0-9]+$ && $selection -ge 1 && $selection -le ${#options[@]} ]]; then
            case ${options[selection - 1]} in
                "Run & Quit")
                    quit_selected=true
                    return
                    ;;
                *)
                    # Toggle selected options
                    if [[ " $selected_options " == *" ${options[selection - 1]} "* ]]; then
                        selected_options="${selected_options//${options[selection - 1]} /}"
                    else
                        selected_options+="${options[selection - 1]} "
                    fi
                    ;;
            esac
        else
            echo "Invalid input: $selection"
        fi
    done
}

# Continue displaying the menu until the user chooses to quit
while [ "$quit_selected" != true ]; do
    show_menu
done

if [ -z "$selected_options" ]; then
    echo "Error: there is no selection, Make a selection before executing the command, ending script."
    exit 1
fi

#|- Final step, showing packages and asking for installation
clear
echo "Here's a backup of the command in case something goes wrong:"
echo -e "\nsudo apt install $selected_options-y" | sudo -u $SUDO_USER tee -a /home/$SUDO_USER/generated_apt_cmd.txt
echo -e "\nThe command is also saved at as /home/$SUDO_USER/generated_apt_cmd.txt"
echo -e "\nPress any key TWICE to allow this script to run the command or close the window..."
read -n 1 -s -r -p "."
read -n 1 -s -r -p "."
echo "."
echo -e "\nRunning apt install!"
sleep 2

apt update
apt upgrade -y
apt install $selected_options-y
apt autoremove -y

echo "Done!"
sleep 3
