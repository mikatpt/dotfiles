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

local follow_symlink = function()
    local file = vim.api.nvim_buf_get_name(0)
    if vim.bo.filetype == 'link' then
        vim.fn.execute('file ' .. vim.fn.resolve(file))
    end
end

M.fn.set_project_root = function()
    follow_symlink()
    vim.cmd('cd %:p:h')

    local git_dir = vim.fn.system('git rev-parse --show-toplevel')
    if not string.find(git_dir, '^fatal:.*') then
        vim.cmd('cd ' .. git_dir)
    end
    require('nvim-tree').change_dir(vim.loop.cwd())
end

M.fn.dashboard_startup = function()
    if vim.api.nvim_buf_get_name(0):len() == 0 then
        vim.cmd('silent! Dashboard')
    end
end

M.fn.setup_packer = function()
    local packer_url = 'https://github.com/wbthomason/packer.nvim'
    local packer_path = M.os.data .. '/site/pack/packer/opt/packer.nvim'
    if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
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
        opt_default = true,
        profile = { enable = true },
    })
end

M.fn.get_local_plugin = function(author, plugin)
    local local_path = M.os.home .. '/foss/' .. plugin
    local remote_path = author .. '/' .. plugin
    if M.os.name == 'Windows_NT' then
        return remote_path
    end
    return vim.fn.isdirectory(local_path) == 1 and local_path or remote_path
end

local options = { noremap = true, silent = true }

M.fn.defer_mouse = function()
    vim.defer_fn(function()
        vim.opt.mouse:append({ a = true, r = true })
    end, 50)
end

M.fn.redraw_lsp = function()
    for _, id in pairs(vim.tbl_keys(vim.lsp.buf_get_clients())) do
        vim.diagnostic.disable(0, id)
        vim.diagnostic.enable(0, id)
    end
end

M.fn.map_lsp = function(mode, lhs, rhs, opts)
    local redraw = '<CMD>lua require"core.utils".fn.redraw_lsp()<CR>'
    vim.api.nvim_set_keymap(mode, lhs, rhs .. redraw, opts or options)
end

M.fn.get_env = function()
    local Path = require('plenary.path')
    local env_file = M.os.config .. '/.env.json'
    return vim.fn.json_decode(Path:new(env_file):read())
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

return M
