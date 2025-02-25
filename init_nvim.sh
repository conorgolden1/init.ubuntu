apt update

# Install Neovim

nvim="~/.nvim/nvim.appimage"

if [ ! -d "~/.nvim" ]; then
   mkdir ~/.nvim
   echo "Made .nvim directory at: ~/.nvim"
fi

echo "Downloading neovim : ~/.nvim/nvim.appimage"

curl -o ~/.nvim/nvim.appimage -L https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
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

git clone https://github.com/conorgolden1/init.lua.git /etc/xdg/nvim/

# Install gcc

apt install gcc g++-multilib -y

# Install RipGrep

curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
dpkg -i ripgrep_13.0.0_amd64.deb
rm ripgrep_13.0.0_amd64.deb


# Run Packer Sync

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
