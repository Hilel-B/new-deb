echo "Starting setup..."

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install tmux
sudo apt install -y tmux

# Download .tmux.conf from GitHub
TMUX_CONF_URL="https://raw.githubusercontent.com/yourusername/dotfiles/main/.tmux.conf"
curl -o ~/.tmux.conf $TMUX_CONF_URL

echo "Setup complete! Restart your terminal or run 'tmux' to start."
