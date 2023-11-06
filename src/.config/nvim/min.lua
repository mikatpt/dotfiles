-- Run using nvim -u min.lua
-- To test using NO plugins, run nvim -u min.lua --clean
--

-- Add plugins here when trying to debug config.
-- Modify configs in `load_config`
local plugins = {
    { 'nvim-lua/plenary.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope.nvim' },
    { 'folke/noice.nvim', dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' } },
}

_G.load_personal = function()
    vim.cmd([[nnoremap <C-P> <cmd>lua require('telescope.builtin').git_files({})<CR>]])
    vim.cmd([[inoremap jk <ESC>]])

    local o = vim.opt
    o.timeoutlen = 200
    o.errorbells = false
end

_G.load_config = function()
    require('telescope').setup({
        defaults = {
            file_ignore_patterns = { 'node_modules/', '.gitignore' },
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = 'smart_case',
            },
        },
    })
    require('telescope').load_extension('fzf')
    load_personal()
end

local package_root = '/tmp/share/nvim/lazy'

local function install_lazy()
    local install_path = package_root .. '/lazy.nvim'
    if vim.fn.isdirectory(install_path) == 0 then
        vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            'https://github.com/folke/lazy.nvim.git',
            '--branch=stable', -- latest stable release
            install_path,
        })
    end
    vim.opt.rtp:prepend(install_path)
end

local function load_plugins(p)
    local opts = {
        root = package_root,
        lockfile = package_root .. '/lazy-lock.json',
    }
    require('lazy').setup(p, opts)
    require('noice').setup({
        lsp = { enabled = false },
        messages = { enabled = false },
    })
end

install_lazy()
load_plugins(plugins)
vim.cmd([[autocmd User VeryLazy ++once echo "Ready!" | lua load_config()]])
