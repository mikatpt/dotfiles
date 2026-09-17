---@diagnostic disable: param-type-mismatch
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
M.keybinds.noreabbrev = bind('na')
M.keybinds.cnoreabbrev = bind('ca')
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

local root_markers = {
    '.git',
    '.hg',
    '.svn',
    'go.mod',
    'go.work',
    'Cargo.toml',
    'package.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'pom.xml',
    'build.gradle',
    'composer.json',
    'Gemfile',
    'mix.exs',
}

-- Outermost directory still joined to `file` by a chain of `marker` files. Used
-- for ecosystems whose libraries carry no manifest (e.g. the Python stdlib),
-- where the package boundary is the only signal of where the unit begins.
local outermost_with = function(file, marker)
    local uv = vim.uv or vim.loop
    local dir = vim.fs.dirname(file)
    if not uv.fs_stat(dir .. '/' .. marker) then
        return nil
    end
    while true do
        local parent = vim.fs.dirname(dir)
        if parent == dir or not uv.fs_stat(parent .. '/' .. marker) then
            return dir
        end
        dir = parent
    end
end

-- Root of the CURRENT buffer, resolved so pickers follow you when you jump into
-- another project or a read-only dependency tree.
M.fn.project_root = function()
    local buf = vim.api.nvim_get_current_buf()
    local fname = vim.api.nvim_buf_get_name(buf)
    if fname == '' then
        return vim.fn.getcwd()
    end

    -- Nearest VCS/manifest marker. `stop` at $HOME keeps a dotfiles repo rooted at
    -- $HOME from swallowing every dependency under it (~/go, ~/.cargo, ...).
    local hit = vim.fs.find(root_markers, { upward = true, path = fname, stop = vim.env.HOME })[1]
    if hit then
        return vim.fs.dirname(hit)
    end

    -- Manifest-less language units. One entry per ecosystem that needs it.
    if fname:match('%.py$') then
        local pkg = outermost_with(fname, '__init__.py')
        if pkg then
            return pkg
        end
    end

    -- An attached LSP client whose root actually contains this file, then cwd.
    for _, c in pairs(vim.lsp.get_clients({ bufnr = buf })) do
        local rd = c.config.root_dir
        if rd and fname:sub(1, #rd) == rd then
            return rd
        end
    end
    return vim.fn.getcwd()
end

-- Find files in the current buffer's project or library: git_files inside a repo,
-- find_files in a plain directory (dependency trees aren't git repos).
M.fn.project_files = function(opts)
    opts = opts or {}
    opts.cwd = M.fn.project_root()
    local uv = vim.uv or vim.loop
    local builtin = require('telescope.builtin')
    if uv.fs_stat(opts.cwd .. '/.git') then
        builtin.git_files(opts)
    else
        builtin.find_files(opts)
    end
end

M.fn.redraw_lsp = function()
    vim.diagnostic.enable(false)
    vim.diagnostic.enable(true)
end

M.fn.reload_lsp = function()
    local active = vim.lsp.get_clients({ bufnr = 0 })
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

M.fn.get_vis_len = function()
    local _, start_row, start_col, _ = unpack(vim.fn.getpos('v'))
    local _, end_row, end_col, _ = unpack(vim.fn.getpos('.'))

    if start_row > end_row then
        start_row, start_col, end_row, end_col = end_row, end_col, start_row, start_col
    end

    local lines = vim.fn.getline(start_row, end_row)
    if #lines == 0 then
        return 0
    end

    -- Slice off unselected text in first and last lines if only partially selected.
    if start_row == end_row then
        lines[1] = string.sub(lines[1], start_col, end_col)
    else
        lines[1] = string.sub(lines[1], start_col)
        lines[#lines] = string.sub(lines[#lines], 1, end_col)
    end

    local text = table.concat(lines, '\n')
    print(vim.fn.strlen(text))
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

M.fn.handler = function(_, result, ctx)
    local hov = require('rust-tools.hover_actions')

    if result and result.contents then
        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents, {})
        local final = {}
        local in_code_block = false
        local code_block_start_pattern = '^```%w+'

        for _, line in ipairs(markdown_lines) do
            if line:match(code_block_start_pattern) then
                -- Start of a code block
                in_code_block = true
                final[#final + 1] = line
            elseif line == '```' and in_code_block then
                -- End of a code block, append to the previous line
                final[#final] = final[#final] .. line
                in_code_block = false
            else
                -- Regular line, just append
                final[#final + 1] = line
            end
        end

        result.contents = table.concat(final, '\n')
    end
    hov.handler(_, result, ctx)
end

-- This bit of hacky pre-processing removes the whitespace between markdown code blocks.
-- It relies on some rust-tools internals, so it could break in the future—but rust-tools isn't
-- being updated anyways.
M.fn.rust_tools_hover = function()
    local rt = require('rust-tools')

    local params = vim.lsp.util.make_position_params(0, 'utf-8')
    vim.lsp.buf_request(0, 'textDocument/hover', params, rt.utils.mk_handler(M.fn.handler))
end

--- @class GbrowseOpts
--- @field target_upstream boolean Target master branch of upstream remote (for better sharing).
--- @field is_visual boolean       Look up cursor position and use visual selection.
--- @field yank boolean            Yank the URL to the clipboard instead of opening it.
---
--- @param opts GbrowseOpts
M.fn.gbrowse = function(opts)
    local target_upstream = opts.target_upstream
    local remotes = vim.fn.systemlist('git remote')
    local has_origin = false
    local has_upstream = false
    local remote = 'origin'

    for _, r in ipairs(remotes) do
        if r == 'origin' then
            has_origin = true
        elseif r == 'upstream' then
            has_upstream = true
        end
    end

    if has_upstream and target_upstream then
        remote = 'upstream'
    elseif not has_upstream and has_origin then
        remote = 'origin'
    else
        remote = remotes[1]
    end

    local main_branch = 'master'
    if vim.fn.system('git branch --list ' .. 'master') == '' then
        main_branch = 'main'
    end

    local start_l, end_l = vim.fn.getpos('v')[2], vim.fn.getpos('.')[2]
    if start_l > end_l then
        start_l, end_l = end_l, start_l
    end

    local range = opts.is_visual and start_l .. ',' .. end_l or ''
    end_l = opts.is_visual and end_l or -1

    if opts.yank then
        local result = vim.fn['fugitive#BrowseCommand'](start_l, end_l, -1, true, '', main_branch .. ':%@' .. remote)
        result = result:gsub('^echo ', ''):gsub("^'", ''):gsub("'$", '')
        vim.fn.setreg('+', result)
        print('+ <' .. result)
        return
    end

    local cmd = range .. 'GBrowse '
    if target_upstream then
        cmd = cmd .. main_branch .. ':%' .. '@' .. remote
    end
    vim.cmd(cmd)
end

return M
