# Usage

## Installation

`sudo bash install.sh`

## Teardown

`sudo bash uninstall.sh`

## Informational

This repository sets up:
- fish shell
- Starship shell prompt
- Neovim
- golang
- python3.9
- nvm/nodeJS


Currently, the script isn't 100% idempotent and is optimized for linux. If you're running on MacOS, you'll have to substitute most things with brew installs.

## Feature Highlights

#### Fish CLI
- `ctrl-z` to suspend any program (usually nvim), and `ctrl-z` again to return.
- `ctrl-r` to fuzzy find through your command line history.
    - `ctrl-n` and `ctrl-p` cycle through options
- `ctrl-t` to fuzzy find through child directories
- `Tab` autocompletion, `ctrl-f` to autocomplete from history

#### Neovim
- See various vim config files for various other keybindings. Files to check out:
    - `nvim/config.vim`
    - `nvim/language/keybindings.vim`

## Neovim setup
* After running the install scripts, run these commands:
```
npm i -g typescript typescript-language-server pyright graphql-language-service-cli
# In nvim
:TSInstall go python javascript graphql typescript rust bash
```

