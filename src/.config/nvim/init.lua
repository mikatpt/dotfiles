-- Source all config files
require('modules')
vim.cmd('runtime! config/**/*.vim')

local empty_buffer = vim.api.nvim_buf_get_name(0):len() == 0

if empty_buffer then
    vim.cmd('silent! Dashboard')
end

local cmd = ':!xdg-open <cWORD> &<CR><CR>'
if require'core.utils'.os.name == 'Darwin' then cmd = ':!open <cWORD> &<CR><CR>' end
vim.api.nvim_set_keymap('n', 'gx', cmd, { silent = false, noremap = true})
