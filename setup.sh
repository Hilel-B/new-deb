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

# Detect package manager
if command -v apt &>/dev/null; then
  INSTALL_CMD="sudo apt install -y"
  UPDATE_CMD="sudo apt update && sudo apt upgrade -y"
elif command -v dnf &>/dev/null; then
  INSTALL_CMD="sudo dnf install -y"
  UPDATE_CMD="sudo dnf update -y"
elif command -v pacman &>/dev/null; then
  INSTALL_CMD="sudo pacman -S --noconfirm"
  UPDATE_CMD="sudo pacman -Syu --noconfirm"
elif command -v zypper &>/dev/null; then
  INSTALL_CMD="sudo zypper install -y"
  UPDATE_CMD="sudo zypper update -y"
else
  echo -e "${RED}Unsupported package manager. Exiting.${RESET}"
  exit 1
fi

echo -e "${YELLOW}Using package manager: ${BLUE}$INSTALL_CMD${RESET}"

# Update and upgrade system
echo -e "${YELLOW}Updating and upgrading system...${RESET}"
eval "$UPDATE_CMD"

# Install Git to first fetch the repo
echo -e "${YELLOW}Installing Git...${RESET}"
eval "$INSTALL_CMD git"

# Clone the repository
if [ -d "$LOCAL_REPO" ]; then
  echo -e "${BLUE}Repository already exists. Pulling latest changes...${RESET}"
  git -C "$LOCAL_REPO" pull
else
  echo -e "${BLUE}Cloning repository...${RESET}"
  git clone "$GITHUB_URL" "$LOCAL_REPO"
fi

# After cloning, define directories
MIGRATE_DIR="$LOCAL_REPO/Migrate"
SCRIPTS_DIR="$LOCAL_REPO/Scripts"
BEFORE_SCRIPTS="$SCRIPTS_DIR/Before"
AFTER_SCRIPTS="$SCRIPTS_DIR/After"

# Function to execute scripts in a directory (sorted by filename)
execute_scripts() {
  local script_dir="$1"
  local phase="$2"

  if [ -d "$script_dir" ]; then
    echo -e "${YELLOW}Running $phase scripts...${RESET}"
    for script in "$script_dir"/*.sh; do
      if [[ -f "$script" && -x "$script" ]]; then
        echo -e "${BLUE}Executing $(basename "$script")...${RESET}"
        bash "$script"
      fi
    done
  fi
}

# Run scripts before installation
execute_scripts "$BEFORE_SCRIPTS" "Before"

# Install software from the "softs" file
SOFTS_FILE="$LOCAL_REPO/softs"

if [ -f "$SOFTS_FILE" ]; then
  echo -e "${YELLOW}Installing software...${RESET}"
  while IFS= read -r software; do
    if [[ -z "$software" || "$software" == \#* ]]; then
      continue
    fi
    echo -e "${BLUE}Installing $software...${RESET}"
    if eval "$INSTALL_CMD $software"; then
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

# Run scripts after migration
execute_scripts "$AFTER_SCRIPTS" "After"

echo -e "${GREEN}Setup complete! Restart your terminal for changes to take effect.${RESET}"
