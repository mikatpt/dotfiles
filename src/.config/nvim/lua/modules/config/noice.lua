return function()
    ---@diagnostic disable: missing-fields
    require('notify').setup({
        timeout = 3,
    })
    require('noice').setup({
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ['vim.lsp.util.convert_input_to_markdown_lines'] = false,
                ['vim.lsp.util.stylize_markdown'] = false,
                ['cmp.entry.get_documentation'] = false,
            },
            progress = { enabled = false },
            signature = { enabled = false },
            documentation = { enabled = false },
            hover = { enabled = false },
            message = { enabled = true, view = 'mini' },
        },
        messages = {
            enabled = true,
            view = 'mini', -- default view for messages
            view_error = 'notify', -- view for errors
            view_warn = 'notify', -- view for warnings
            view_history = 'messages', -- view for :messages
            view_search = 'mini', -- view for search count messages. Set to `false` to disable
        },
        presets = {
            long_message_to_split = true,
        },
        routes = { -- see :h noice and search FILTERS for more filtering options.
            { -- show mode changes and @recording messages
                filter = { event = 'msg_showmode' },
                view = 'mini',
            },
            {
                filter = {
                    event = 'notify',
                    min_height = 10,
                },
                view = 'split',
            },
            {
                filter = {
                    event = 'msg_show',
                    min_height = 10,
                },
                view = 'messages',
            },
            { -- filter out undo messages
                filter = {
                    event = 'msg_show',
                    any = {
                        { find = '; after #%d+' },
                        { find = '; before #%d+' },
                        { find = '%d fewer lines' },
                        { find = '%d more lines' },
                    },
                },
                opts = { skip = true },
            },
            {
                filter = {
                    kind = 'emsg',
                    find = 'E486: Pattern not found',
                },
                view = 'mini',
            },
        },
        views = {
            mini = {
                position = {
                    row = '1%',
                    col = '60%',
                },
            },
            cmdline_popup = {
                position = {
                    row = 13,
                    col = 13,
                },
                border = {
                    style = 'none',
                    padding = { 1, 2 },
                },
                size = {
                    width = 60,
                    height = 'auto',
                },
                win_options = {
                    winhighlight = { Normal = 'CursorLine' },
                },
            },
            popupmenu = {
                relative = 'editor',
                position = {
                    row = 16,
                    col = 15,
                },
                size = {
                    width = 30,
                    height = 9,
                },
                border = {
                    style = 'single',
                    padding = { 0, 1 },
                },
                win_options = {
                    winhighlight = { Normal = 'CursorLine' },
                },
            },
        },
    })
end
