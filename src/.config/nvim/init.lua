-- Source all config files
require('modules')
vim.cmd('runtime! config/**/*.vim')

local empty_buffer = vim.api.nvim_buf_get_name(0):len() == 0

if empty_buffer then
    vim.cmd('silent! Dashboard')
end

local isDarwin = require('core.utils').os.name == 'Darwin'
local cmd = isDarwin and ':!open <cWORD> &<CR><CR>' or ':!xdg-open <cWORD> &<CR><CR>'

vim.api.nvim_set_keymap('n', 'gx', cmd, { silent = false, noremap = true })
