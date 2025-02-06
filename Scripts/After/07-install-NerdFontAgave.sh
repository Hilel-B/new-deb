#!/bin/bash

# Install Agave Nerd Font
echo "Installing Agave Nerd Font..."

# Ensure fontconfig is installed
if ! command -v fc-cache &> /dev/null || ! command -v fc-list &> /dev/null; then
    echo "Installing fontconfig..."
    sudo apt update && sudo apt install -y fontconfig
fi

# Create font directory for the user
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

# Download the font
echo "Downloading Agave Nerd Font..."
curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Agave.zip

# Extract the font
echo "Extracting Agave Nerd Font..."
unzip -o Agave.zip -d agave-nerd-font
rm Agave.zip  # Clean up

# Refresh font cache
echo "Updating font cache..."
fc-cache -fv

# Verify installation
if fc-list | grep -i "Agave"; then
    echo "Agave Nerd Font installed successfully!"
else
    echo "Error: Agave Nerd Font installation failed."
    exit 1
fi

# Check if the --system-wide parameter is passed
if [[ "$1" == "--system-wide" ]]; then
    echo "Installing system-wide..."

    # Install system-wide font
    sudo mkdir -p /usr/share/fonts/nerd-fonts
    sudo cp -r ~/.local/share/fonts/agave-nerd-font /usr/share/fonts/nerd-fonts/
    sudo fc-cache -fv
    echo "System-wide installation complete!"
else
    echo "Font installed for the user only."
fi

echo "Done!"
