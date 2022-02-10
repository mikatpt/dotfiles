# Usage

## Installation

```
cd ~
git clone https://github.com/mikatpt/dotfiles.git
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
```
# These scripts are also run during install.sh/uninstall.sh

# To stow
sudo bash configure.sh

# To unstow:
sudo bash unconfigure.sh
```

## Informational

The install script sets up:
- fish shell
- Starship shell prompt
- Neovim
- golang
- python3.9
- nvm/nodeJS
- rust

No promises on full idempotency.

## Feature Highlights

#### CLI
- `ctrl-z` to suspend any program (usually nvim), and `ctrl-z` again to return.
- `ctrl-r` to fuzzy find through your command line history.
    - `ctrl-n` and `ctrl-p` cycle through options
- `ctrl-t` to fuzzy find through child directories
- `Tab` autocompletion, `ctrl-f` to autocomplete from history
- zoxide: predictive cd; for example, `z DIRNAME`
- tealdeer: type `tldr COMMAND` for a summary of options
- fd-find/ripgrep/exa: improved versions of find/grep/ls

#### Neovim
- tl;dr, files to check out for mappings and plugins:
    - `src/.config/nvim/core/map.lua`
    - `src/.config/nvim/lua/modules/init.lua`
