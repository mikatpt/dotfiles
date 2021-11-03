-- Global variables
vim.g.netrw_browse_split = 0
vim.g.netrw_liststyle = 4
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 75
vim.g.vim_markdown_fenced_languages = { 'html', 'python', 'go', 'bash=sh', 'javascript', 'typescript' }
vim.g.vim_markdown_folding_disabled = 1
vim.g.fugitive_github_domains = { 'github.com', 'github.cbhq.net' }
vim.g.vsnip_snippet_dir = '~/config/src/.config/nvim/snippets'
vim.g.vsnip_filetypes = {}
vim.g.vsnip_filetypes.javascriptreact = { 'javascript' }
vim.g.vsnip_filetypes.typescriptreact = { 'javascript' }
vim.g.vsnip_filetypes.typescript = { 'javascript' }

local o = vim.opt

-- This is to fix a neovim render bug in indent-blankline.
o.colorcolumn = '9999'

-- Basic Editor Settings
o.errorbells = false
o.hlsearch = false
o.hidden = true
o.termguicolors = true
o.background = 'dark'
vim.cmd('colo lucid_nvim')
o.cmdheight = 1
o.updatetime = 300
o.shortmess:append({ c = true, a = true, s = true })
o.mouse:append({ a = true, r = true })
o.timeoutlen = 200
o.wildmenu = true
o.wildmode = { 'longest:full', 'full' }
o.shell = '/bin/bash'
o.formatoptions:remove({ 'c', 'r', 'o' })
o.conceallevel = 2
-- set list
-- set listchars=lead:.

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
o.undodir = require('core.utils').os.data .. '/undodir'
o.undofile = true
o.incsearch = true
o.splitright = true
o.smartcase = true
o.ignorecase = true
o.completeopt = { 'menuone', 'noselect' }

-- Indent preferences
vim.cmd('autocmd FileType javascript setlocal shiftwidth=2 tabstop=2')
vim.cmd('autocmd FileType typescript setlocal shiftwidth=2 tabstop=2')
vim.cmd('autocmd FileType javascriptreact setlocal shiftwidth=2 tabstop=2')
vim.cmd('autocmd FileType typescriptreact setlocal shiftwidth=2 tabstop=2')
