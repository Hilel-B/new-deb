LV_BRANCH='release-1.4/neovim-0.9' LV_AUTO_INSTALL=y bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)
echo 'export PATH=/root/.local/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
