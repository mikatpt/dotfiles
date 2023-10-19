local M = {}

M.fn = {}

local bind = function(mode, outer_opts)
    outer_opts = outer_opts or { silent = true }
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend('force', outer_opts, opts or {})
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

local map_lsp = function(mode, lhs, rhs, opts)
    local redraw = '<CMD>lua require"core.utils".fn.redraw_lsp()<CR>'
    vim.api.nvim_set_keymap(mode, lhs, rhs .. redraw, opts or { silent = true, noremap = true })
end

M.keybinds = {}

M.keybinds.imap = bind('i', { silent = true, noremap = false })
M.keybinds.smap = bind('s', { silent = true, noremap = false })
M.keybinds.xnoremap = bind('x')
M.keybinds.nnoremap = bind('n')
M.keybinds.vnoremap = bind('v')
M.keybinds.inoremap = bind('i')
M.keybinds.cnoremap = bind('c')
M.keybinds.icnoremap = bind('!')
M.keybinds.map_lsp = map_lsp

-- TODO: change to use vim.fn.system
local windows_git_dir = function()
    vim.cmd('silent! !git rev-parse --is-inside-work-tree')
    return vim.v.shell_error == 0
end

M.fn.is_git_dir = function()
    if vim.loop.os_uname().sysname == 'Windows_NT' then
        return windows_git_dir()
    end
    return os.execute('git rev-parse --is-inside-work-tree >> /dev/null 2>&1') == 0
end

M.fn.redraw_lsp = function()
    for _, id in pairs(vim.tbl_keys(vim.lsp.get_clients())) do
        vim.diagnostic.disable(0, id)
        vim.diagnostic.enable(0, id)
    end
end

M.fn.reload_lsp = function()
    local active = require('lspconfig').util.get_active_clients_list_by_ft(vim.bo.filetype)
    if #active > 0 then
        vim.cmd('LspRestart')
    end
end

M.fn.reload_config = function()
    -- Plenary actually unloads plugins, so we have to manually set them back up.
    -- Tried reloading base modules but that upsets packer - this workaround does functionally the same thing.
    local reload = require('plenary.reload').reload_module
    local plugin_configs = require('modules.config')

    reload('core', true)
    reload('modules.config', true)
    reload('modules.lspconfig', true)

    ---@diagnostic disable-next-line: lowercase-global
    packer_plugins = packer_plugins or {}
    for plugin, _ in pairs(packer_plugins) do
        reload(plugin, true)
        pcall(require, plugin)
        pcall(require, string.gsub(plugin, '.nvim', ''))
    end

    for _, setup in pairs(plugin_configs) do
        setup()
    end

    vim.cmd("execute 'source ' . stdpath('config') . '/init.lua'")
end

M.fn.setup_lazy = function()
    local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            'git',
            'clone',
            '--filter=blob:none',
            'https://github.com/folke/lazy.nvim.git',
            '--branch=stable', -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)
end

M.fn.setup_packer = function()
    local packer_url = 'https://github.com/wbthomason/packer.nvim'
    local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
    if vim.fn.empty(vim.fn.glob(packer_path, nil, false)) > 0 then
        print('Downloading plugin manager...')
        vim.cmd('silent! !git clone ' .. packer_url .. ' ' .. packer_path)
    end

    vim.cmd('packadd packer.nvim')

    local disabled_built_ins = {
        'getscript',
        'getscriptPlugin',
        '2html_plugin',
        'logipat',
        'rrhelper',
        'spellfile_plugin',
        'matchit',
    }

    for _, plugin in pairs(disabled_built_ins) do
        vim.g['loaded_' .. plugin] = 1
    end

    require('packer').init({
        compile_path = vim.fn.stdpath('data') .. '/site/lua/packer_compiled.lua',
        opt_default = false,
        profile = { enable = true },
    })
end

return M
