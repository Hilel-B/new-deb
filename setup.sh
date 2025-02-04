echo "Starting setup..."

REPO="new-deb"

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install Git to first fetch the repo
sudo apt install git -y

git clone https://github.com/Hilel-B/"$REPO".git

# Install software from the "softs" file
echo "Installing software..."
while IFS= read -r software; do
  # Skip empty lines or comments
  if [[ -z "$software" || "$software" == \#* ]]; then
    continue
  fi
  
  # Install the software
  echo "Installing $software..."
  sudo apt install -y "$software"
done < "softs"

echo "Installation complete!"

# Download .tmux.conf from GitHub
#TMUX_CONF_URL="https://raw.githubusercontent.com/yourusername/dotfiles/main/.tmux.conf"
#curl -o ~/.tmux.conf $TMUX_CONF_URL

echo "Setup complete! Restart your terminal or run 'tmux' to start."
