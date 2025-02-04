#!/bin/bash

# Configuration variables

# Define color variables
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
RESET="\e[0m"

# Define GitHub repository details
REPO="new-deb"
GITHUB_URL="https://github.com/Hilel-B/$REPO.git"
LOCAL_REPO="$HOME/$REPO"
MIGRATE_DIR="$LOCAL_REPO/Migrate"
SCRIPTS_DIR="$LOCAL_REPO/Scripts"
BEFORE_SCRIPTS="$SCRIPTS_DIR/Before"
AFTER_SCRIPTS="$SCRIPTS_DIR/After"

# Package manager detection and commands
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
  echo -e "Unsupported package manager. Exiting."
  exit 1
fi
