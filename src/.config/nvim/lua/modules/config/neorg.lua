return function()
    local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()
    parser_configs.norg = {
        install_info = {
            url = 'https://github.com/nvim-neorg/tree-sitter-norg',
            files = { 'src/parser.c', 'src/scanner.cc' },
            branch = 'main',
        },
    }

    require('neorg').setup({
        load = {
            ['core.defaults'] = {
                config = {
                    -- lazy load cmp.
                    disable = (function()
                        local ok = pcall('cmp')
                        if ok then
                            return {}
                        else
                            vim.cmd('PackerLoad lspkind-nvim nvim-cmp')
                            return { 'core.norg.completion' }
                        end
                    end)(),
                },
            },
            ['core.norg.concealer'] = {},
            ['core.norg.completion'] = {
                config = { engine = 'nvim-cmp' },
            },
            ['core.norg.dirman'] = {
                config = {
                    workspaces = {
                        notes = '~/notes',
                    },
                },
            },
        },
        hook = function()
            -- local neorg_leader = "<Leader>" -- You may also want to set this to <Leader>o for "organization"
            local neorg_callbacks = require('neorg.callbacks')
            neorg_callbacks.on_event('core.keybinds.events.enable_keybinds', function(_, keybinds)
                keybinds.map_event_to_mode('norg', {
                    n = { -- Bind keys in normal mode
                        { 'gtd', 'core.norg.qol.todo_items.todo.task_done' },
                        { 'gtu', 'core.norg.qol.todo_items.todo.task_undone' },
                        { 'gtp', 'core.norg.qol.todo_items.todo.task_pending' },
                        { '<C-Space>', 'core.norg.qol.todo_items.todo.task_cycle' },
                    },
                }, {
                    silent = true,
                    noremap = true,
                })
            end)
        end,
    })
end
