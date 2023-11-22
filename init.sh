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

# Install gcc

apt install gcc g++-multilib -y

# Install RipGrep

curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
dpkg -i ripgrep_13.0.0_amd64.deb
rm ripgrep_13.0.0_amd64.deb

# Install Hack font

curl -L --output hack_font.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.0/Hack.zip
unzip hack_font.zip -d ttf/
if $wsl; then
    mv -v ttf/* /usr/share/fonts/
    rfc-cache -f -v
else
    if [ ! -d "$HOME/.fonts" ]; then
        mkdir "$HOME/.fonts"
    fi
    mv -v ttf/* "$HOME/.fonts/"
fi
rm hack_font.zip
rm -Rf ttf/


# Install Github Cli

type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y


# Store Github credentials

gh auth login


# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#Install Node
nvm install node
nvm use node


# Run Packer Sync

nvim --headless -c 'autocmd User PackerComplete quitall'
nvim --headless -c 'PackerSync'
nvim --headless -c 'PackerSync'

