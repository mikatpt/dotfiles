require('modules')

local buffer_name = vim.api.nvim_buf_name(0)
local no_file_open = buffer_name:len() == 0
local is_dir = vim.fn.isdirectory(buffer_name)

if no_file_open or is_dir then
    vim.cmd('silent! PackerLoad nvim-tree.lua')
    vim.cmd('silent! PackerLoad dashboard-nvim')
    vim.cmd('silent! Dashboard')
    vim.cmd('silent! NvimTreeOpen')
end
