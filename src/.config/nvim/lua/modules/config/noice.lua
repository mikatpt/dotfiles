return function()
    local cnoreabbrev = require('core.utils').keybinds.cnoreabbrev

    cnoreabbrev('mes', 'Noice')
    -- stylua: ignore start
    for _, mes in ipairs({ 'Mes', 'MEs', 'MES' }) do
        cnoreabbrev(mes, 'mes')
    end
    for wrong, right in pairs({ qq = 'q', QQ = 'q', Qq = 'q', Q = 'q', qqa = 'qa', QQa = 'qa', Qqa = 'qa', W = 'w', Wq = 'wq', Wqa = 'wqa' }) do
        cnoreabbrev(wrong, right)
    end
    -- stylua: ignore end

    require('noice').setup({
        commands = {
            history = {
                view = 'split',
                opts = { enter = true, format = 'details' },
                -- Exclude undo messages and search messages from history, include the rest.
                filter = {
                    any = {
                        { event = 'notify' },
                        { error = true },
                        { warning = true },
                        { event = 'msg_show', ['not'] = { find = '^[/?].*' } },
                        { event = 'lsp', kind = 'message' },
                    },
                    ['not'] = {
                        any = {
                            { event = 'msg_show', kind = '', find = '%d+ more lines?' },
                            { event = 'msg_show', kind = '', find = '%d+ fewer lines' },
                            { event = 'msg_show', kind = '', find = '%d+ line less' },
                            { event = 'msg_show', kind = '', find = '%d+ change' },
                            { event = 'msg_show', kind = 'bufwrite', ['not'] = { find = '%[w%]' } }, -- exclude weird dupe write events.
                        },
                    },
                },
            },
        },
        lsp = {
            -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
            override = {
                ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                ['vim.lsp.util.stylize_markdown'] = true,
            },
            progress = { enabled = false },
            signature = { enabled = false },
            documentation = { enabled = true },
            hover = { enabled = false },
            message = { enabled = true, view = 'mini' },
        },
        messages = {
            enabled = true,
            view = 'mini', -- default view for messages
            view_error = 'notify', -- view for errors
            view_warn = 'notify', -- view for warnings
            view_history = 'messages', -- view for :messages
            view_search = false, -- view for search count messages. Set to `false` to disable
        },
        presets = {
            long_message_to_split = true,
        },
        routes = { -- see :h noice and search FILTERS for more filtering options.
            {
                -- Exclude from notifying.
                filter = {
                    any = {
                        { event = 'msg_show', kind = '', find = '%d+ more lines?' },
                        { event = 'msg_show', kind = '', find = '%d+ fewer lines' },
                        { event = 'msg_show', kind = '', find = '%d+ line less' },
                        { event = 'msg_show', kind = '', find = '%d+ change' },
                        { event = 'notify', kind = 'warn', find = 'position_encoding' },
                        { event = 'notify', kind = 'warn', find = 'offset_encodings detected' },
                    },
                },
                opts = { skip = true },
            },
            { filter = { min_height = 5 }, view = 'split' },
            {
                filter = { -- route some obtrusive messages to the mini view
                    any = {
                        { kind = 'emsg', find = 'E486: Pattern not found' },
                        { event = 'notify', kind = 'info', find = 'No information available' },
                        { event = 'msg_show', kind = 'bufwrite' },
                        { event = 'msg_show', kind = 'echomsg', find = 'deprecated' },
                    },
                },
                view = 'mini',
            },
        },
        views = {
            split = { enter = true },
            mini = {
                position = {
                    row = '98%',
                    col = '20%',
                },
                border = { style = 'rounded' },
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
