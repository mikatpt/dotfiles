# Usage

## Installation

```
cd ~
git clone https://github.com/mikatpt/config.git
sudo bash install.sh
```
- Make sure you clone this repository to your home directory!

- If you would like to use fish as your default shell, after setup run the following command:

```
sudo chsh -s `which fish`
```

## Teardown

```
sudo bash uninstall.sh
```

## Configure without installing
This repository uses GNU stow to manage dotfiles:
all folders and files in the `src` directory will be symlinked to your home directory.

## Informational

The install script sets up:
- fish shell
- Starship shell prompt
- Neovim
- golang
- python3.9
- nvm/nodeJS

Currently, the script isn't 100% idempotent and is optimized for linux. If you're running on MacOS, no guarantees on perfection!

## Feature Highlights

#### Fish CLI
- `ctrl-z` to suspend any program (usually nvim), and `ctrl-z` again to return.
- `ctrl-r` to fuzzy find through your command line history.
    - `ctrl-n` and `ctrl-p` cycle through options
- `ctrl-t` to fuzzy find through child directories
- `Tab` autocompletion, `ctrl-f` to autocomplete from history

#### Neovim
- See various vim config files for various other keybindings. Files to check out:
    - `src/.config/nvim/config/keybindings.vim`
    - `src/.config/nvim/lua/core/keybindings.vim`

## Neovim setup
* If you would like syntax highlighting, autocomplete, and formatting, run below commands for the relevant languages.
```
npm i -g typescript typescript-language-server pyright graphql-language-service-cli vscode-langservers-extracted dockerfile-language-server-nodejs
# In nvim
:TSInstall go python javascript graphql typescript rust bash dockerfile json jsonc
```

