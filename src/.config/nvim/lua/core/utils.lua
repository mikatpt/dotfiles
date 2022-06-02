local M = {}

M.os = {
    data = vim.fn.stdpath('data'),
    cache = vim.fn.stdpath('cache'),
    config = vim.fn.stdpath('config'),
    name = vim.loop.os_uname().sysname,
}

local home = M.os.name == 'Windows_NT' and 'HOMEPATH' or 'HOME'
M.os.home = os.getenv(home)

M.fn = {}

-- TODO: change to use vim.fn.system
local windows_git_dir = function()
    vim.cmd('silent! !git rev-parse --is-inside-work-tree')
    return vim.v.shell_error == 0
end

M.fn.is_git_dir = function()
    if M.os.name == 'Windows_NT' then
        return windows_git_dir()
    end
    return os.execute('git rev-parse --is-inside-work-tree >> /dev/null 2>&1') == 0
end

M.fn.dashboard_startup = function()
    if vim.api.nvim_buf_get_name(0):len() == 0 then
        vim.cmd('silent! Alpha')
    end
end

M.fn.get_local_plugin = function(author, plugin)
    local local_path = M.os.home .. '/foss/' .. plugin
    local remote_path = author .. '/' .. plugin
    if M.os.name == 'Windows_NT' then
        return remote_path
    end
    return vim.fn.isdirectory(local_path) == 1 and local_path or remote_path
end

M.fn.defer_mouse = function()
    vim.defer_fn(function()
        vim.opt.mouse:append({ a = true, r = true })
    end, 50)
end

M.fn.auto_close_tree = function()
    local au_group_id = vim.api.nvim_create_augroup('AutoCloseNvimTree', { clear = true })

    local cb = function()
        local ft = vim.bo.filetype
        if _G.auto_close_called or ft == 'NvimTree' or ft == 'TelescopePrompt' or ft == '' then
            return
        end

        _G.auto_close_called = true
        vim.defer_fn(function()
            vim.api.nvim_create_autocmd('BufEnter', {
                command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
                nested = true,
            })
        end, 1000)
        vim.api.nvim_del_augroup_by_id(au_group_id)
    end

    vim.api.nvim_create_autocmd('BufEnter', {
        group = au_group_id,
        callback = cb,
    })
end

M.fn.redraw_lsp = function()
    for _, id in pairs(vim.tbl_keys(vim.lsp.buf_get_clients(nil))) do
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

M.fn.setup_packer = function()
    local packer_url = 'https://github.com/wbthomason/packer.nvim'
    local packer_path = M.os.data .. '/site/pack/packer/opt/packer.nvim'
    if vim.fn.empty(vim.fn.glob(packer_path, nil, nil)) > 0 then
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
        compile_path = M.os.data .. '/site/lua/packer_compiled.lua',
        opt_default = false,
        profile = { enable = true },
    })
end

return M
