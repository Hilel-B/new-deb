#!/bin/bash

# Define color variables
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

echo -e "${CYAN}Starting setup...${RESET}"

REPO="new-deb"
GITHUB_URL="https://github.com/Hilel-B/$REPO.git"
LOCAL_REPO="$HOME/$REPO"

# Update and upgrade system
echo -e "${YELLOW}Updating and upgrading system...${RESET}"
sudo apt update && sudo apt upgrade -y

# Install Git to first fetch the repo
echo -e "${YELLOW}Installing Git...${RESET}"
sudo apt install git -y

# Clone the repository
if [ -d "$LOCAL_REPO" ]; then
  echo -e "${BLUE}Repository already exists. Pulling latest changes...${RESET}"
  git -C "$LOCAL_REPO" pull
else
  echo -e "${BLUE}Cloning repository...${RESET}"
  git clone "$GITHUB_URL" "$LOCAL_REPO"
fi

# Install software from the "softs" file
SOFTS_FILE="$LOCAL_REPO/softs"

if [ -f "$SOFTS_FILE" ]; then
  echo -e "${YELLOW}Installing software...${RESET}"
  while IFS= read -r software; do
    if [[ -z "$software" || "$software" == \#* ]]; then
      continue
    fi
    echo -e "${BLUE}Installing $software...${RESET}"
    if sudo apt install -y "$software"; then
      echo -e "${GREEN}$software installed successfully!${RESET}"
    else
      echo -e "${RED}Failed to install $software!${RESET}"
    fi
  done < "$SOFTS_FILE"
else
  echo -e "${RED}No 'softs' file found in the repository.${RESET}"
fi

# Copy configuration files with backup
echo -e "${YELLOW}Copying configuration files with backup...${RESET}"

for dir in $(find "$LOCAL_REPO" -mindepth 1 -type d); do
  target_dir="/$(basename "$dir")"  # Get the name of the folder and prepend "/"
  
  # Ensure the directory exists
  sudo mkdir -p "$target_dir"

  echo -e "${BLUE}Copying files to $target_dir (with backup if exists)...${RESET}"
  sudo cp -r --backup=numbered "$dir/"* "$target_dir/"

  echo -e "${GREEN}Files copied to $target_dir successfully!${RESET}"
done

echo -e "${GREEN}Setup complete! Restart your terminal for changes to take effect.${RESET}"
