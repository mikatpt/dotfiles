require('modules')

local empty_buffer = vim.api.nvim_buf_get_name(0):len() == 0

if empty_buffer then
    vim.cmd('silent! Dashboard')
end
