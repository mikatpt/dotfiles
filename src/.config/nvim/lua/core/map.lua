-- stylua: ignore start
local utils = require('core.utils')
local isDarwin = vim.loop.os_uname().sysname == 'Darwin'
local open_cmd = isDarwin and ':!open <cWORD> &<CR><CR>' or ':!xdg-open <cWORD> &<CR><CR>'

local nonsilent = { silent = false }

local bind = function(mode, outer_opts)
    outer_opts = outer_opts or { silent = true }
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend('force', outer_opts, opts or {})
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

local map_lsp = function(mode, lhs, rhs, opts)
    local redraw = '<CMD>lua require"core.utils".fn.redraw_lsp()<CR>'
    vim.api.nvim_set_keymap(mode, lhs, rhs .. redraw, opts or { silent = true, noremap = true})
end

-- :h map-listing
-- local nmap = bind('n', { silent = true, noremap = false })
-- local xnoremap = bind('x')
local nnoremap = bind('n')
local vnoremap = bind('v')
local inoremap = bind('i')
local cnoremap = bind('c')
local icnoremap = bind('!')

vim.g.mapleader = ' '
inoremap('jk',            '<ESC>')
nnoremap('Y',             'y$')
nnoremap('Q',             '@@')
nnoremap('<F1>',          '<nop>')

-- Magic search
nnoremap('?',             '?\\v')
nnoremap('/',             '/\\v')
cnoremap('%s/',           '%sm/')

-- terminal bindings for command line mode
cnoremap('<C-A>',         '<Home>',  nonsilent)
cnoremap('<C-E>',         '<End>',   nonsilent)
cnoremap('<C-B>',         '<Left>',  nonsilent)
cnoremap('<C-F>',         '<Right>', nonsilent)
vim.cmd('set cedit=<C-G>')

-- Merge lines
nnoremap('<S-M>',         '<S-J>')

-- Use J and K to move lines up and down.
nnoremap('<S-K>',         ':m .-2<CR>==')
nnoremap('<S-J>',         ':m .+1<CR>==')
vnoremap('J',             ":m '>+1<CR>gv=gv")
vnoremap('K',             ":m '<-2<CR>gv=gv")

-- Indenting won't throw you out of visual mode
vnoremap('<LT>',          '<LT>gv')
vnoremap('>',             '>gv')

-- Fix ctrl backspace behavior
icnoremap('<C-BS>',       '<C-W>')
icnoremap('<C-H>',        '<C-W>')

-- misc convenience stuff.
map_lsp('i', '<C-J>',     '<Esc>o')
map_lsp('i', '<C-CR>',    '<Esc><S-O>')
map_lsp('n', '<C-G>',     'A;<Esc>') -- C-G is equivalent to <C-'>
map_lsp('i', '<C-G>',     '<Esc>A;')

-- From vim-commentary:
-- gc to comment out lines

-- Resize splits
nnoremap('<S-LEFT>',      ':vert res -5<CR>')
nnoremap('<S-RIGHT>',     ':vert res +5<CR>')
nnoremap('<S-UP>',        ':res +5<CR>')
nnoremap('<S-DOWN>',      ':res -5<CR>')

-- Use space j or k to open new splits, and Ctrl hjkl to move between them.
nnoremap('<leader>j',     ':split<CR>',           nonsilent)
nnoremap('<leader>k',     ':vsp<CR>',             nonsilent)
nnoremap('<leader>u',     ':sp<CR>',              nonsilent)
nnoremap('<leader><S-J>', ':topleft vsp<CR>',     nonsilent)
nnoremap('<leader><S-K>', ':vsp<CR>',             nonsilent)
nnoremap('<C-J>',         '<C-W><S-W>')
nnoremap('<C-K>',         '<C-W>w')
nnoremap('<C-H>',         '<C-W>h')
nnoremap('<C-L>',         '<C-W>l')

-- File Tree
nnoremap('<C-N>',         ':NvimTreeToggle<CR>')
nnoremap('<leader>nf',    ':NvimTreeFindFile<CR>')
nnoremap('<leader>nr',    ':NvimTreeRefresh<CR>', nonsilent)

-- set current working directory to current file
nnoremap('<leader>cd',    ':cd %:p:h<CR>',        nonsilent)

-- Toggle relative/absolute line numbers
nnoremap('<leader>l',     ':set rnu!<CR>',        nonsilent)

-- Yank to system clipboard
nnoremap('<leader>y',     '"+y')
vnoremap('<leader>y',     '"+y')
nnoremap('<leader><S-Y>', '<CMD>%y+<CR>')

-- Open URL
nnoremap('gx',            open_cmd,               nonsilent)

-- Open in Github
nnoremap('<leader>go',    '<CMD>GBrowse<CR>')
-- Git merge
nnoremap('<leader>hj',    '<CMD>diffget //2<CR>' )
nnoremap('<leader>hk',    '<CMD>diffget //3<CR>' )

-- Reload neovim configuration and LSP
nnoremap('<leader>rl',         function() require('core.utils').fn.reload_lsp() end)
nnoremap('<leader>rr',         function() require('core.utils').fn.reload_config() end, nonsilent)

-- Harpoon
nnoremap('<leader><S-P><S-M>', function() require('harpoon-finder.mark').toggle_dir() end)
nnoremap('<leader><S-P><S-N>', function() require('harpoon-finder.ui').toggle_quick_menu() end)
nnoremap('<leader>p',          function() require('harpoon-finder.ui').find_files() end)
nnoremap('<leader><S-F>',      function() require('telescope.builtin').live_grep({ prompt_title = 'Find Text', layout_strategy = 'vertical', search_dirs = require('harpoon-finder.ui').get_search_dirs() }) end)

nnoremap('<leader>m',          function() require('harpoon.mark').toggle_file() end)
nnoremap('<leader><S-M>',      function() require('harpoon.ui').toggle_quick_menu() end)
for i = 1, 9 do
    nnoremap('<leader>' .. i,  function() require('harpoon.ui').nav_file(i) end)
end

-- Telescope
local telescope_cmd = utils.fn.is_git_dir() and 'git_files' or 'find_files'
local cfg_path = vim.fn.stdpath('config')
nnoremap('<C-P>',              '<CMD>Telescope ' .. telescope_cmd .. '<CR>')

nnoremap('<leader>o',          '<CMD>Telescope oldfiles file_ignore_patterns={}<CR>')
nnoremap('<leader>z',          function() require('telescope.builtin').git_files({ prompt_title = 'Dotfiles', cwd = cfg_path, file_ignore_patterns = {} }) end)
nnoremap('<leader>s',          function() require('telescope.builtin').lsp_dynamic_workspace_symbols({ prompt_title = 'Search Symbols', layout_strategy = 'vertical' }) end)
nnoremap('<leader>b',          function() require('telescope.builtin').buffers() end)
nnoremap('<leader>q',          '<CMD>TroubleToggle document_diagnostics<CR>')
nnoremap('<leader>Q',          '<CMD>TroubleToggle workspace_diagnostics<CR>')

-- Ripgrep for input or current word
nnoremap('<leader>f',          function() require('telescope.builtin').live_grep({ prompt_title = 'Find Text', layout_strategy = 'vertical' }) end)
nnoremap('<leader>w',          '<CMD>TodoTelescope layout_strategy=vertical<CR>')

-- DB
nnoremap('<leader><S-D>',      '<CMD>DBUIToggle<CR>')

-- Debugging
nnoremap('<F5>',               function() require('dapui').open({})require('dap').continue() end)
nnoremap('<F10>',              function() require('dap').step_over({}) end)
nnoremap('<F11>',              function() require('dap').step_into() end)
nnoremap('<F12>',              function() require('dap').step_out() end)
nnoremap('<C-Y>',              function() require('dapui').toggle({}) end)
nnoremap('<leader>d',          function() require('dapui').eval(nil, nil) end)
vnoremap('<leader>d',          function() require('dapui').eval(nil, nil) end)
nnoremap('<C-B>',              function() require('dap').toggle_breakpoint() end)
