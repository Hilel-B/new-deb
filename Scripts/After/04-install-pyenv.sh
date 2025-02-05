# install dependencies
sudo apt install -y curl git-core zlib1g-dev libssl-dev libreadline-dev libbz2-dev libsqlite3-dev
curl https://pyenv.run | bash
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
source ~/.bashrc

py_version="3.11.6"

pyenv install "${py_version}"   # Change version as needed
pyenv global "${py_version}"
