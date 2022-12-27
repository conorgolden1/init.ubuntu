#!/bin/bash

# Checks internet access

echo -e "GET http://google.com HTTP/1.0\n\n" | nc google.com 80 > /dev/null 2>&1

if [ $? -ne 0 ]; then
 echo "Error: Cannot connect to the internet"
 exit 1
fi


# Checks to see if we are running in a WSL instance

wsl=$( [ $(grep -io Microsoft /proc/version) = "microsoft" ] ); 


# Install Rustup

if $wsl; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    curl https://sh.rustup.rs -sSf | sh
fi

# Install Neovim

nvim="~/.nvim/nvim.appimage"

if [ ! -d "~/.nvim" ]; then
   mkdir ~/.nvim
   echo "Made .nvim directory at: ~/.nvim"
fi

echo "Downloading neovim : ~/.nvim/nvim.appimage"

curl -o ~/.nvim/nvim.appimage -L https://github.com/neovim/neovim/releases/latest/download/nvim.appimage

chmod u+x ~/.nvim/nvim.appimage

cd ~/.nvim/ && { ./nvim.appimage --appimage-extract; cd -; }

if [ -d "/etc/nvim" ]; then
   rm -Rf /etc/nvim
   echo "Removed old /etc/nvim"
fi

mv ~/.nvim/squashfs-root /etc/nvim

if [ -h "/usr/bin/nvim" ]; then
   rm /usr/bin/nvim
   echo "Removed old /usr/bin/nvim symlink"
fi

ln -s /etc/nvim/AppRun /usr/bin/nvim

# Clean up Neovim downloads

rm -Rf ~/.nvim/


# Download Neovim Config

if [ -d "/etc/xdg/nvim" ]; then
   rm -Rf /etc/xdg/nvim
   echo "Removed old nvim config in /etc/xdg/nvim"
fi

git clone https://github.com/goldencm/init.lua.git /etc/xdg/nvim/


