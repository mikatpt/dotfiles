return function()
    return {
        keymap = {
            preset = 'enter',
            ['<Tab>'] = {
                function(cmp)
                    if cmp.snippet_active() then
                        return cmp.snippet_forward()
                    else
                        return cmp.select_next()
                    end
                end,
                'select_next',
                'fallback',
            },
            ['<S-Tab>'] = {
                function(cmp)
                    if cmp.snippet_active() then
                        return cmp.snippet_backward()
                    else
                        return cmp.select_next()
                    end
                end,
                'select_prev',
                'fallback',
            },
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        snippets = { preset = 'luasnip' },
        signature = { enabled = false },
        completion = {
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },
            list = {
                selection = {
                    preselect = function(_)
                        return not require('blink.cmp').snippet_active({ direction = 1 })
                    end,
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0,
            },
            menu = {
                enabled = true,
                auto_show = true,
                draw = {
                    columns = {
                        { 'label', 'label_description', gap = 1 },
                        { 'kind_icon', gap = 1, 'kind' },
                    },
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local lspkind = require('lspkind')
                                local icon = ctx.kind_icon
                                if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                                    local dev_icon, _ = require('nvim-web-devicons').get_icon(ctx.label)
                                    if dev_icon then
                                        icon = dev_icon
                                    end
                                else
                                    icon = lspkind.symbolic(ctx.kind, {
                                        mode = 'symbol',
                                    })
                                end

                                return icon .. ctx.icon_gap
                            end,

                            -- Optionally, use the highlight groups from nvim-web-devicons
                            -- You can also add the same function for `kind.highlight` if you want to
                            -- keep the highlight groups in sync with the icons.
                            highlight = function(ctx)
                                local hl = 'BlinkCmpKind' .. ctx.kind
                                    or require('blink.cmp.completion.windows.render.tailwind').get_hl(ctx)
                                if vim.tbl_contains({ 'Path' }, ctx.source_name) then
                                    local dev_icon, dev_hl = require('nvim-web-devicons').get_icon(ctx.label)
                                    if dev_icon then
                                        hl = dev_hl
                                    end
                                end
                                return hl
                            end,
                        },
                    },
                },
            },
        },
    }
end
