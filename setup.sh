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
MIGRATE_DIR="$LOCAL_REPO/Migrate"

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

# Copy configuration files from "Migrate" while ignoring ".git"
if [ -d "$MIGRATE_DIR" ]; then
  echo -e "${YELLOW}Copying configuration files from Migrate/...${RESET}"
  
  for dir in "$MIGRATE_DIR"/*; do
    if [[ -d "$dir" && "$(basename "$dir")" != ".git" ]]; then
      if [[ "$(basename "$dir")" == "home" ]]; then
        target_dir="$HOME"  # Map "Migrate/home" to ~ (home directory)
      else
        target_dir="/$(basename "$dir")"  # Other directories go to /
      fi
      
      # Ensure the directory exists
      sudo mkdir -p "$target_dir"

      echo -e "${BLUE}Copying files to $target_dir (with backup if exists)...${RESET}"
      sudo cp -r --backup=numbered "$dir/"* "$target_dir/"

      echo -e "${GREEN}Files copied to $target_dir successfully!${RESET}"
    fi
  done
else
  echo -e "${RED}No 'Migrate' directory found in the repository.${RESET}"
fi

echo -e "${GREEN}Setup complete! Restart your terminal for changes to take effect.${RESET}"
