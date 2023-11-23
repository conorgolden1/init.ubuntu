### Goldencm's ubuntu init.sh
This build script has only been tested so far on WSL2 and may
or may not be compatible with another linux distro

### Requirements
You need at least WSL2 or Ubuntu. This script must be run with root privliges
for proper installation.

## Warning
This script by default will attempt to install a neovim config (mine by
default) in the /etc/xdg/nvim directory. This will install the neovim config
system wide. If that is your desired behavior then your neovim config requires
a sysinit.vim initialization file

### Run
For standard install see below:
```
sudo sh init.sh
```
For just neovim see below:
```
sudo sh init_nvim.sh
```
(For either run 'PackerSync' twice in neovim)

### Installed Apps

1. Rustup
2. Neovim
3. Gcc
4. Github Cli (for git authentication)
5. Ripgrep
6. Nvm (Node version manager)
7. Node (Most recent version of node)
8. Hack Font
9. [FD](https://github.com/sharkdp/fd)
10. Build-Essential
11. Treesitter
12. Tmux

## Post Installation
After running you must change font in terminal profile. Currently you need to run PackerSync twice after opening neovim. The headless
syncing appears to run into some errors that I will work out in the future.



