# curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
# # sudo rm -rf /opt/nvim
# # sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
# # echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
# sudo rm -rf /opt/nvim
# sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
# sudo mv /opt/nvim-linux64 /opt/nvim
# echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc

# source ~/.bashrc


# sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/bin/nvim

#!/bin/bash

# Download the latest Neovim release
echo "Downloading latest Neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz

# Remove any existing Neovim installation
sudo rm -rf /opt/nvim

# Extract Neovim to /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo mv /opt/nvim-linux64 /opt/nvim  # Rename to a clean folder name

# Ensure Neovim is accessible in the system path
sudo ln -sf /opt/nvim/bin/nvim /usr/bin/nvim

# Add Neovim to the user's PATH (for safety)
echo 'export PATH="/opt/nvim/bin:$PATH"' >> ~/.bashrc

# Apply changes
source ~/.bashrc

# Verify installation
nvim --version
