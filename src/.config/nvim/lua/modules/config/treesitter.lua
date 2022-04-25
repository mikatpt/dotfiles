return function()
    require('nvim-treesitter.configs').setup({
        autotag = {
            enable = true,
        },
        ensure_installed = 'all',
        ignore_install = { 'tlaplus', 'norg' },
        autopairs = { enable = true },
        indent = {
            enable = true,
            disable = { 'python', 'lua', 'go', 'yaml', 'json', 'jsonc', 'html', 'css' },
        },
        highlight = {
            enable = true, -- false will disable the whole extension
            disable = {}, -- list of language that will be disabled
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = true,
        },
        -- From treesitter-refactor plugin
        refactor = {
            highlight_definitions = { enable = true },
        },
    })
end
