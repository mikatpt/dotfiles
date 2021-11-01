-- stylua: ignore start
local utils = require('core.utils')
local map = utils.fn.map
local isDarwin = utils.os.name == 'Darwin'
local open_cmd = isDarwin and ':!open <cWORD> &<CR><CR>' or ':!xdg-open <cWORD> &<CR><CR>'

local nonsilent = { silent = false, noremap = true }

vim.g.mapleader = ' '
map('i', 'jk',                 '<ESC>')
map('n', 'Y',                  'y$')
map('n', 'Q',                  '@@')

-- Merge lines
map('n', '<S-M>',              '<S-J>')

-- Use J and K to move lines up and down.
map('n', '<S-K>',              ':m .-2<CR>==')
map('n', '<S-J>',              ':m .+1<CR>==')
map('v', 'J',                  ":m '>+1<CR>gv=gv")
map('v', 'K',                  ":m '<-2<CR>gv=gv")

-- Indenting won't throw you out of visual mode
map('v', '<LT>',               '<LT>gv')
map('v', '>',                  '>gv')

-- Fix ctrl backspace behavior
map('!', '<C-BS>',             '<C-W>')
map('!', '<C-H>',              '<C-W>')

-- misc convenience stuff.
map('i', '<C-J>',              '<Esc>o')
map('i', '<S-CR>',             '<Esc>O')

-- From vim-commentary:
-- gc to comment out lines

-- Resize splits
map('n', '<S-LEFT>',           ':vert res -5<CR>')
map('n', '<S-RIGHT>',          ':vert res +5<CR>')
map('n', '<S-UP>',             ':res +5<CR>')
map('n', '<S-DOWN>',           ':res -5<CR>')

-- Use space j or k to open new splits, and Ctrl hjkl to move between them.
map('n', '<leader>j',          ':split<CR>',           nonsilent)
map('n', '<leader>k',          ':vsp<CR>',             nonsilent)
map('n', '<leader>u',          ':sp<CR>',              nonsilent)
map('n', '<leader><S-J>',      ':topleft vsp<CR>',     nonsilent)
map('n', '<leader><S-K>',      ':vsp<CR>',             nonsilent)
map('n', '<C-J>',              '<C-W><S-W>')
map('n', '<C-K>',              '<C-W>w')
map('n', '<C-H>',              '<C-W>h')
map('n', '<C-L>',              '<C-W>l')

-- File Tree
map('n', '<C-N>',              ':NvimTreeToggle<CR>')
map('n', '<leader>nf',         ':NvimTreeFindFile<CR>')
map('n', '<leader>nr',         ':NvimTreeRefresh<CR>', nonsilent)

-- Reload the current buffer (to refresh lsp)
map('n', '<leader>rl',         ':LspRestart<CR>',      nonsilent)

-- set current working directory to current file
map('n', '<leader>cd',         ':cd %:p:h<CR>',        nonsilent)

-- Toggle relative/absolute line numbers
map('n', '<leader>l',          ':set rnu!<CR>',        nonsilent)

-- Yank to system clipboard
map('n', '<leader>y',          '"+y')
map('v', '<leader>y',          '"+y')

-- Open URL
map('n', 'gx',                 open_cmd,               nonsilent)

-- Open in Github
map('n', '<leader>go',         '<CMD>GBrowse<CR>')

-- Harpoon
map('n', '<leader><S-P><S-M>', '<CMD>lua require"harpoon-finder.mark".toggle_dir()<CR>')
map('n', '<leader><S-P><S-N>', '<CMD>lua require"harpoon-finder.ui".toggle_quick_menu()<CR>')
map('n', '<leader>p',          '<CMD>lua require"harpoon-finder.ui".find_files()<CR>')
map('n', '<leader><S-F>',      '<CMD>lua require"telescope.builtin".live_grep({ prompt_title = "Find Text", layout_strategy = "vertical", search_dirs = require"harpoon-finder.ui".get_search_dirs() })<CR>')

map('n', '<leader>m',          ':lua require("harpoon.mark").toggle_file()<CR>')
map('n', '<leader><S-M>',      ':lua require("harpoon.ui").toggle_quick_menu()<CR>')
for i = 1, 9 do
    map('n', '<leader>' .. i,  ':lua require("harpoon.ui").nav_file(' .. i .. ')<CR>')
end

-- Telescope
if utils.fn.is_git_dir() == 0 then
    map('n', '<C-P>',          '<CMD>Telescope find_files<CR>')
else
    map('n', '<C-P>',          '<CMD>Telescope git_files<CR>')
end
map('n', '<leader>o',          '<CMD>Telescope oldfiles file_ignore_patterns={}<CR>')
map('n', '<leader>z',          '<CMD>lua require"telescope.builtin".git_files({ prompt_title = "Config Files", cwd = "$HOME/.config/nvim", file_ignore_patterns = {} })<CR>')
map('n', '<leader>b',          '<CMD>Telescope buffers<CR>')
map('n', '<leader>s',          '<CMD>lua require"telescope.builtin".lsp_dynamic_workspace_symbols({ prompt_title = "Search Symbols", layout_strategy = "vertical" })<CR>')

-- Ripgrep for input or current word
map('n', '<leader>f',          '<CMD>lua require("telescope.builtin").live_grep({ prompt_title = "Find Text", layout_strategy = "vertical" })<CR>')
map('n', '<leader>w',          '<CMD>TodoTelescope layout_strategy=vertical<CR>')

-- Debugging
map('n', '<F5>',               ':lua require"dap".continue()<CR>')
map('n', '<F10>',              ':lua require"dap".step_over()<CR>')
map('n', '<F11>',              ':lua require"dap".step_into()<CR>')
map('n', '<F12>',              ':lua require"dap".step_out()<CR>')
map('n', '<C-B>',              ':lua require"dap".toggle_breakpoint()<CR>')
map('n', '<leader>d',          ':lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>')
