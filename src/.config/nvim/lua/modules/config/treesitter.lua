-- Apparently has to be global for treesitter to pick up on it
function __Disable_on_large_files(_, bufnr)
    local max_size = 100 * 1024 -- 100KB
    local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))

    if file_size > max_size then
        vim.defer_fn(function()
            vim.notify('mikatpt: disabling Treesitter for files > 100KB', vim.log.levels.WARN)
        end, 50)
        return true
    end
    return false
end

local default_cfg = {
    enable = true,
    disable = __Disable_on_large_files,
}

return function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = 'all',
        ignore_install = { 'tlaplus', 'norg' },
        autotag = default_cfg,
        autopairs = { enable = true },
        indent = {
            enable = true,
            disable = { 'python', 'lua', 'go', 'yaml', 'json', 'jsonc', 'html', 'css', 'rust' },
        },
        highlight = {
            enable = true, -- false will disable the whole extension
            disable = {},
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = true,
        },
        -- From treesitter-refactor plugin
        refactor = {
            highlight_definitions = default_cfg,
            highlight_current_scope = default_cfg,
            navigation = { enable = false },
            smart_rename = { enable = false },
        },
        incremental_selection = default_cfg,
    })
end
