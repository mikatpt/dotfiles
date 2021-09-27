local utils = require('core.utils')
local packer_url = 'https://github.com/wbthomason/packer.nvim'
local packer_path = utils.os.data .. '/site/pack/packer/opt/packer.nvim'

local M = {}

M.setup = function()
    if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
        print('Downloading plugin manager...')
        vim.cmd('silent! !git clone ' .. packer_url .. ' ' .. packer_path)
    end

    vim.cmd('packadd packer.nvim')

    local disabled_built_ins = {
        "getscript", "getscriptPlugin",
        "2html_plugin", "logipat",
        "rrhelper", "spellfile_plugin", "matchit"
    }

    for _, plugin in pairs(disabled_built_ins) do
        vim.g["loaded_" .. plugin] = 1
    end

    require'packer'.init({
        compile_path = utils.os.data .. '/site/lua/packer_compiled.lua',
        opt_default = true,
        profile = { enable = true },
    })
end

return M

