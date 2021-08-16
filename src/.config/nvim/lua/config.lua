require('modules')

if vim.api.nvim_buf_get_name(0):len() == 0 then
    vim.cmd('silent! Dashboard')
end
