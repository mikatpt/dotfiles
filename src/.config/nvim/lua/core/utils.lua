local M = {}

M.os = {
    home = os.getenv('HOME'),
    data = vim.fn.stdpath('data'),
    cache = vim.fn.stdpath('cache'),
    config = vim.fn.stdpath('config'),
    name = vim.loop.os_uname().sysname,
}

M.fn = {}

M.fn.is_git_dir = function()
    if os.execute('git rev-parse --is-inside-work-tree >> /dev/null 2>&1') == 0 then
        return 1
    else
        return 0
    end
end

-- author: tjdevries
M.fn.get_lua_runtime = function()
    local result = {}
    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
        local lua_path = path .. '/lua/'
        if vim.fn.isdirectory(lua_path) then
            result[lua_path] = true
        end
    end

    -- This loads the `lua` files from nvim into the runtime.
    result[vim.fn.expand('$VIMRUNTIME/lua')] = true

    return result
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
    local local_path = M.os.home .. '/' .. plugin
    local remote_path = author .. '/' .. plugin
    return vim.fn.isdirectory(local_path) == 1 and local_path or remote_path
end

local options = { noremap = true, silent = true }

M.fn.map = function(mode, lhs, rhs, opts)
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts or options)
end

M.fn.buf_map = function(mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts or options)
end

M.fn.defer_mouse = function()
    vim.defer_fn(function()
        vim.opt.mouse:append({ a = true, r = true })
    end, 50)
end

M.fn.redraw_lsp = function()
    for _, id in pairs(vim.tbl_keys(vim.lsp.buf_get_clients())) do
        vim.lsp.diagnostic.disable(0, id)
        vim.lsp.diagnostic.enable(0, id)
    end
end

M.fn.map_redraw = function(mode, lhs, rhs, opts)
    local redraw = '<CMD>lua require"core.utils".fn.redraw_lsp()<CR>'
    vim.api.nvim_set_keymap(mode, lhs, rhs .. redraw, opts or options)
end

return M
