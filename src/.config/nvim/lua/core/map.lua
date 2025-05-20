-- stylua: ignore start
local utils = require('core.utils')
local isDarwin = vim.loop.os_uname().sysname == 'Darwin'
local open_cmd = isDarwin and ':!open <cWORD> &<CR><CR>' or ':!xdg-open <cWORD> &<CR><CR>'

-- :h map-listing
local nnoremap = utils.keybinds.nnoremap
local vnoremap = utils.keybinds.vnoremap
local inoremap = utils.keybinds.inoremap
local cnoremap = utils.keybinds.cnoremap
local icnoremap = utils.keybinds.icnoremap
-- local cnoreabbrev = utils.keybinds.cnoreabbrev

local map_lsp = utils.keybinds.map_lsp

local nonsilent = { silent = false }

vim.g.mapleader = ' '
inoremap('jk',            '<ESC>')
nnoremap('Y',             'y$')
nnoremap('Q',             '@@')
nnoremap('<F1>',          '<nop>')

-- terminal bindings for command line mode
cnoremap('<C-A>',         '<Home>',  nonsilent)
cnoremap('<C-E>',         '<End>',   nonsilent)
cnoremap('<C-B>',         '<Left>',  nonsilent)
cnoremap('<C-F>',         '<Right>', nonsilent)
vim.api.nvim_set_option_value('cedit', '<C-G>', {})

-- Merge lines
nnoremap('<S-M>',         '<S-J>')
-- we use m for hover now
nnoremap('<S-L>',         'm')

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

if vim.g.vscode then
    nnoremap('<S-LEFT>',  ':call VSCodeNotify("workbench.action.decreaseViewSize")<CR>')
    nnoremap('<S-RIGHT>', ':call VSCodeNotify("workbench.action.increaseViewSize")<CR>')
    nnoremap('<S-UP>',    ':call VSCodeNotify("workbench.action.increaseViewSize")<CR>')
    nnoremap('<S-DOWN>',  ':call VSCodeNotify("workbench.action.decreaseViewSize")<CR>')

    nnoremap('<leader>j', ':call VSCodeNotify("workbench.action.splitEditorDown")<CR>', nonsilent)
    nnoremap('<leader>k', ':call VSCodeNotify("workbench.action.splitEditor")<CR>',     nonsilent)
    nnoremap('<leader>u', ':call VSCodeNotify("workbench.action.splitEditorUp")<CR>', nonsilent)
    nnoremap('<leader><S-J>', ':call VSCodeNotify("workbench.action.splitEditorDown")<CR>:call VSCodeNotify("workbench.action.focusFirstEditorGroup")<CR>', nonsilent)
    nnoremap('<leader><S-K>', ':call VSCodeNotify("workbench.action.splitEditor")<CR>:call VSCodeNotify("workbench.action.focusFirstEditorGroup")<CR>', nonsilent)
    nnoremap('<C-J>', ':call VSCodeNotify("workbench.action.focusNextGroup")<CR>')
    nnoremap('<C-K>', ':call VSCodeNotify("workbench.action.focusPreviousGroup")<CR>')
    nnoremap('<C-H>', ':call VSCodeNotify("workbench.action.focusLeftGroup")<CR>')
    nnoremap('<C-L>', ':call VSCodeNotify("workbench.action.focusRightGroup")<CR>')

    nnoremap('<leader>y', ':call VSCodeNotify("editor.action.clipboardCopyWithSyntaxHighlightingAction")<CR>')
    vnoremap('<leader>y', ':call VSCodeNotify("editor.action.clipboardCopyWithSyntaxHighlightingAction")<CR>')
    nnoremap('<leader><S-Y>', ':call VSCodeNotify("editor.action.clipboardCopyWithSyntaxHighlightingAction")<CR>')
    nnoremap('<leader><S-Y>', ':call VSCodeNotify("editor.action.selectAll")<CR>:call VSCodeNotify("editor.action.clipboardCopyAction")<CR>')
    nnoremap('<C-P>', ':call VSCodeNotify("workbench.action.quickOpen")<CR>')
    nnoremap('<leader>f', ':call VSCodeNotify("workbench.action.findInFiles")<CR>')
    nnoremap(']c', ':call VSCodeNotify("workbench.action.editor.nextChange")<CR>')
    nnoremap('[c', ':call VSCodeNotify("workbench.action.editor.previousChange")<CR>')
    nnoremap(']d', ':call VSCodeNotify("editor.action.marker.next")<CR>')
    nnoremap('[d', ':call VSCodeNotify("editor.action.marker.prev")<CR>')
    nnoremap('<leader>hs', ':call VSCodeNotify("git.stageSelectedRanges")<CR>')
    nnoremap('<leader>hr', ':call VSCodeNotify("git.revertSelectedRanges")<CR>')
    nnoremap('<leader>hu', ':call VSCodeNotify("git.unstageSelectedRanges")<CR>')
    vnoremap('<leader>hs', ':call VSCodeNotify("git.stageSelectedRanges")<CR>')
    vnoremap('<leader>hr', ':call VSCodeNotify("git.revertSelectedRanges")<CR>')
    vnoremap('<leader>hu', ':call VSCodeNotify("git.unstageSelectedRanges")<CR>')
    nnoremap('<leader>HS', ':call VSCodeNotify("git.stage")<CR>')
    nnoremap('<leader>HR', ':call VSCodeNotify("git.clean")<CR>')
    nnoremap('<leader>HU', ':call VSCodeNotify("git.unstage")<CR>')
    return
end

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

-- Get selection length
vnoremap('<leader>l', function() require('core.utils').fn.get_vis_len() end)

-- Yank to system clipboard
nnoremap('<leader>y',     '"+y')
vnoremap('<leader>y',     '"+y')
nnoremap('<leader><S-Y>', '<CMD>%y+<CR>')

-- Open URL
nnoremap('gx',            open_cmd,               nonsilent)

-- Open in Github
nnoremap('<leader>go',         '<CMD>GBrowse<CR>')
nnoremap('<leader><S-G><S-O>', function() require('core.utils').fn.gbrowse({ target_upstream = true }) end)
vnoremap('<leader>go',         function() require('core.utils').fn.gbrowse({ is_visual = true }) end)
vnoremap('<leader><S-G><S-O>', function() require('core.utils').fn.gbrowse({ is_visual = true, target_upstream = true }) end)

-- Yank in github
nnoremap('<leader>gy',         function() require('core.utils').fn.gbrowse({ yank = true }) end)
nnoremap('<leader><S-G><S-Y>', function() require('core.utils').fn.gbrowse({ yank = true, target_upstream = true }) end)
vnoremap('<leader>gy',         function() require('core.utils').fn.gbrowse({ yank = true, is_visual = true }) end)
vnoremap('<leader><S-G><S-Y>', function() require('core.utils').fn.gbrowse({ yank = true, is_visual = true, target_upstream = true }) end)

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
local cfg_path = vim.fn.stdpath('config')
nnoremap('<C-P>',              function() require('telescope.builtin').git_files({}) end)

nnoremap('<leader>o',          '<CMD>Telescope oldfiles file_ignore_patterns={}<CR>')
nnoremap('<leader>z',          function() require('telescope.builtin').git_files({ prompt_title = 'Dotfiles', cwd = cfg_path, file_ignore_patterns = {} }) end)
nnoremap('<leader>s',          function() require('telescope.builtin').lsp_dynamic_workspace_symbols({ prompt_title = 'Search Symbols', layout_strategy = 'vertical' }) end)
nnoremap('<leader>b',          function() require('telescope.builtin').buffers() end)
nnoremap('<leader>q',          '<CMD>TroubleToggle document_diagnostics<CR>')
nnoremap('<leader>Q',          '<CMD>TroubleToggle workspace_diagnostics<CR>')

-- Ripgrep for input or current word
nnoremap('<leader>f',          function() require('telescope.builtin').live_grep({ prompt_title = 'Find Text', layout_strategy = 'vertical' }) end)
vnoremap('<leader>f',          function() require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cword>'), layout_strategy = 'vertical' }) end)
nnoremap('<leader>w',          '<CMD>TodoTelescope layout_strategy=vertical<CR>')

-- DB
nnoremap('<leader><S-D>',      '<CMD>DBUIToggle<CR>')
