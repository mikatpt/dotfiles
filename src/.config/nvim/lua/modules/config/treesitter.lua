return function()
    local parsers = require('nvim-treesitter.parsers').maintained_parsers()
    for i, v in ipairs(parsers) do
        if v == 'tlaplus' then
            table.remove(parsers, i)
            break
        end
    end

    require('nvim-treesitter.configs').setup({
        ensure_installed = parsers,
        autopairs = { enable = true },
        indent = {
            enable = true,
            disable = { 'python' },
        },
        highlight = {
            enable = true, -- false will disable the whole extension
            disable = {}, -- list of language that will be disabled
            -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
            -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
            -- Using this option may slow down your editor, and you may see some duplicate highlights.
            -- Instead of true it can also be a list of languages
            additional_vim_regex_highlighting = false,
        },
        -- From treesitter-refactor plugin
        refactor = {
            highlight_definitions = { enable = true },
        },
    })
end
