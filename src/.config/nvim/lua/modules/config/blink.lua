return function()
    local has_words_before = function()
        local col = vim.api.nvim_win_get_cursor(0)[2]
        if col == 0 then
            return false
        end
        local line = vim.api.nvim_get_current_line()
        return line:sub(col, col):match('%s') == nil
    end

    return {
        enabled = function()
            return not vim.tbl_contains(
                { 'TelescopePrompt', 'NvimTree', 'help', 'lazy', 'mason', 'Trouble', 'notify', 'sagarename' },
                vim.bo.filetype
            )
        end,
        keymap = {
            preset = 'enter',
            ['<Enter>'] = {
                function(cmp)
                    if cmp.is_active() then
                        return cmp.accept()
                    else
                        return cmp.close()
                    end
                end,
                'accept',
                'fallback',
            },
            ['<Tab>'] = {
                function(cmp)
                    if cmp.snippet_active() then
                        return cmp.snippet_forward()
                    elseif has_words_before() then
                        return cmp.insert_next()
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
                        return cmp.select_prev()
                    end
                end,
                'select_prev',
                'fallback',
            },
        },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
            providers = {
                cmdline = {
                    enabled = function()
                        return vim.fn.getcmdtype() ~= ':' or not vim.fn.getcmdline():match("^[%%0-9,'<>%-]*!")
                    end,
                },
                buffer = {
                    enabled = true,
                    min_keyword_length = 7,
                },
            },
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
                    preselect = function(ctx)
                        if ctx.kind == 'Text' then
                            P('found text')
                            return false
                        end
                        -- if require('blink.cmp').snippet_active({ direction = 1 }) then
                        --     return false
                        -- end
                        return true
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
