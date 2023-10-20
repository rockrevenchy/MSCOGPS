#!/bin/bash

# Initialize an empty variable to store selected options
selected_options=""

# Function to display the menu
options=("Option 1" "Option 2" "Option 3" "Option 4" "Option 5" "Quit")

# Set the prompt to create a two-column effect
PS3=$'\n'"Select options (use space to mark/unmark, press Enter to finish): "

# Flag to control the loop
quit_selected=false

# Function to display the menu
show_menu() {
    clear
    echo "Selected options: $selected_options"
    echo " "
    echo "Select options (re-select to remove from your list)"
    echo "These will be installed as .deb packages via apt:"
    
    # Calculate the number of options per column
    options_per_column=$(( (${#options[@]} + 1) / 2 ))
    
    # Display the options in two columns
    for ((i = 0; i < options_per_column; i++)); do
        echo "  $((i + 1)). ${options[i]}   $((i + options_per_column + 1)). ${options[i + options_per_column]}"
    done

    # Prompt the user for input
    read -p "Enter your selection (separated by spaces): " selections

    # Process user input
    for selection in $selections; do
        case ${options[selection - 1]} in
            "Option 1"|"Option 2"|"Option 3"|"Option 4"|"Option 5")
                # Toggle selected options
                if [[ " $selected_options " == *" ${options[selection - 1]} "* ]]; then
                    selected_options="${selected_options// ${options[selection - 1]} /}"
                else
                    selected_options+="${options[selection - 1]} "
                fi
                ;;
            "Quit")
                # Set the flag to true to exit the loop
                quit_selected=true
                return
                ;;
            *)
                echo "Invalid option"
                ;;
        esac
    done
}

# Continue displaying the menu until the user chooses to quit
while [ "$quit_selected" != true ]; do
    show_menu
done

# Print the selected options
echo "Selected options: $selected_options"
