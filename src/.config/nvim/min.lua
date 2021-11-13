-- Add plugins here when trying to debug config. Run using nvim -u min.lua
-- If you'd like to test with NO plugins at all, make a min.vim and run with nvim -u min.vim --clean

vim.cmd([[set runtimepath=$VIMRUNTIME]])
vim.cmd([[set packpath=/tmp/nvim/site]])

local package_root = '/tmp/nvim/site/pack'
local install_path = package_root .. '/packer/start/packer.nvim'

local function install_packer()
    if vim.fn.isdirectory(install_path) == 0 then
        print('Installing Telescope and dependencies.')
        vim.fn.system({ 'git', 'clone', '--depth=1', 'https://github.com/wbthomason/packer.nvim', install_path })
    end
end

local function load_plugins()
    require('packer').startup({
        {
            'wbthomason/packer.nvim',
            {
                'nvim-telescope/telescope.nvim',
                requires = {
                    'nvim-lua/plenary.nvim',
                    { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
                },
            },
        },
        config = {
            package_root = package_root,
            compile_path = install_path .. '/plugin/packer_compiled.lua',
            display = { non_interactive = true },
        },
    })
end

_G.load_config = function()
    require('telescope').setup({
        defaults = {
            file_ignore_patterns = { 'node_modules/', '.gitignore' },
        },
    })
    require('telescope').load_extension('fzf')
end

install_packer()
load_plugins()
require('packer').sync()

vim.cmd([[autocmd User PackerComplete ++once echo "Ready!" | lua load_config()]])
