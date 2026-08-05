---@diagnostic disable: missing-fields

local MAX_FILE_SIZE = 1000 * 1024

local function file_is_large(bufnr)
    local ok, size = pcall(vim.fn.getfsize, vim.api.nvim_buf_get_name(bufnr))
    if not ok or size <= MAX_FILE_SIZE then
        return false
    end
    if not vim.b[bufnr].__disable_large_called then
        vim.b[bufnr].__disable_large_called = true
        vim.defer_fn(function()
            vim.notify('mikatpt: disabling Treesitter for files > 1MB', vim.log.levels.WARN)
            if vim.fn.exists(':IBLDisable') > 0 then
                vim.cmd(':IBLDisable')
            end
        end, 50)
    end
    return true
end

local indent_disabled = {
    python = true,
    lua = true,
    go = true,
    yaml = true,
    json = true,
    jsonc = true,
    html = true,
    css = true,
    rust = true,
}

return function()
    require('nvim-treesitter').setup({})

    -- Bootstrap only: if no parsers exist yet, kick off `install('all')` once.
    -- Ongoing updates are handled by lazy.nvim's `build = ':TSUpdate'` hook.
    if vim.fn.executable('tree-sitter') == 1 then
        local installed = require('nvim-treesitter.config').get_installed('parsers')
        if #installed == 0 then
            pcall(function()
                require('nvim-treesitter').install('all')
            end)
        end
    end

    local group = vim.api.nvim_create_augroup('mikatpt_treesitter', { clear = true })

    -- macOS 26 (Tahoe) prompts per-load for unsigned/duplicate-identifier dylibs.
    -- tree-sitter-cli compiles every parser with the same linker-signed identifier
    -- ("parser.so"), so re-sign each with a unique ad-hoc identifier after install.
    if vim.uv.os_uname().sysname == 'Darwin' then
        vim.api.nvim_create_autocmd('User', {
            group = group,
            pattern = 'TSUpdate',
            callback = function()
                local install_dir = vim.fs.joinpath(vim.fn.stdpath('data'), 'site', 'parser')
                vim.system({ 'sh', '-c', 'for f in "$1"/*.so; do codesign --force --sign - "$f" >/dev/null 2>&1; done', 'sh', install_dir }, { detach = true })
            end,
        })
    end

    vim.api.nvim_create_autocmd('FileType', {
        group = group,
        callback = function(args)
            local bufnr, ft = args.buf, args.match
            if ft == '' or file_is_large(bufnr) then
                return
            end

            if not pcall(vim.treesitter.start, bufnr) then
                return
            end

            if not indent_disabled[ft] then
                vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end

            -- Python keeps the built-in vim regex highlighter running alongside
            -- treesitter (matches the pre-migration `additional_vim_regex_highlighting`).
            if ft == 'python' then
                vim.bo[bufnr].syntax = 'ON'
            end
        end,
    })
end
