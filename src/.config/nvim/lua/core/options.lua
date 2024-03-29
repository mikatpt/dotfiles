-- For some reason, all vim.o options are typed as tables.
---@diagnostic disable assign-type-mismatch
-- Global variables
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 4
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 75
vim.g.vim_markdown_fenced_languages = {
    'html',
    'python',
    'go',
    'bash=sh',
    'javascript',
    'typescript',
    'javascript=js',
    'typescript=ts',
    'sh=bash',
    'rust=rs',
}
vim.g.vim_markdown_folding_disabled = 1
vim.g.fugitive_github_domains = { 'github.com', 'github.cbhq.net' }

local o = vim.opt
-- This is to fix a neovim render bug in indent-blankline.
o.colorcolumn = '9999'

-- Basic Editor Settings
o.errorbells = false
o.hlsearch = false
o.hidden = true
o.termguicolors = true
o.background = 'dark'
vim.cmd('syntax on')
o.cmdheight = 1
o.updatetime = 300
o.shortmess:append({ c = true, a = true, s = true })
o.mouse:append({ a = true, r = true })
o.timeoutlen = 200
o.wildmenu = true
o.wildmode = { 'longest:full', 'full' }
o.shell = vim.loop.os_uname().sysname == 'Windows_NT' and 'cmd.exe' or '/bin/bash'
o.formatoptions:remove({ 'c', 'r', 'o', 't' }) -- :h fo-table
o.textwidth = 100
o.conceallevel = 2
o.fileformat = 'unix'
o.fillchars = 'eob: '

-- Tabs
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

-- Line Numbers and Error Column
o.relativenumber = true
o.number = true
o.scrolloff = 8
o.signcolumn = 'yes'

-- File tree things
o.swapfile = false
o.backup = false
o.writebackup = false
o.undodir = vim.fn.stdpath('data') .. '/undodir'
o.undofile = true
o.incsearch = true
o.splitright = true
o.smartcase = true
o.ignorecase = true
o.completeopt = { 'menuone', 'noselect' }
