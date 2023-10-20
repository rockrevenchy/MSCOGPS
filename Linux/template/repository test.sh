#!/bin/bash

repositories=(
    "https://ppa.launchpadcontent.net/jonaski/strawberry/ubuntu"
    "https://txos-extra.tuxedocomputers.com/ubuntu"
    "https://mirrors.tuxedocomputers.com/ubuntu/mirror/archive.ubuntu.com/ubuntu"
)

# Function to check if a repository exists
check_repository() {
    local repository_url="$1"

    # Check if the repository exists in the sources.list file or sources.list.d
    if grep -q "$repository_url" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        echo "Repository found in system: $repository_url"
        return 0  # Success
    else
        echo "Repository NOT found in system: $repository_url"
        return 1  # Failure
    fi
}

# Check all repositories
all_repositories_exist=true
for repository in "${repositories[@]}"; do
    if ! check_repository "$repository"; then
        all_repositories_exist=false
    fi
done

# Check if all repositories are detected
if $all_repositories_exist; then
    echo "All repositories detected. Proceeding with the rest of the script..."
    # Add your own script here
else
    echo "Not all repositories detected. Performing additional steps before proceeding..."
    # Add additional steps or script here
    # Then, proceed with the rest of the script if needed
fi
