# Script to setup the environment on new Debian install

### apt install curl then run this script to automatize everything
```
bash <(curl -s https://raw.githubusercontent.com/Hilel-B/new-deb/main/setup.sh)
```
### setup.sh will:
#### install git \
#### run scripts located at Scripts/Before \
#### fetch this repo \
#### install all softwares listed in "softs" \
#### run scripts located at Scripts/After \
#### move everything in "Migrate" to corresponding directories in target system, the name of the directory correspond to where everything inside will be put, like in following example: \

new-deb/ \
│── softs                # List of software to install \
│── Migrate/             # Only this folder is processed \
│   ├── etc/             # Will be copied to /etc/ \
│   │   ├── some-config.conf → /etc/some-config.conf \
│   ├── home/            # Will be copied to /home/ \
│   │   ├── .bashrc → /home/.bashrc \
│   ├── usr/local/bin/   # Will be copied to /usr/local/bin/ \
│   │   ├── custom-script → /usr/local/bin/custom-script \
│── some-other-folder/   # Ignored \
│── .git/                # Ignored \

#### run scripts located at Scripts/Complete \
