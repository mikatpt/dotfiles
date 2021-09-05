return function()
    local cmp = require'cmp'
    local types = require'cmp.types'
    local compare = require'cmp.config.compare'
    local lspkind = require'lspkind'
    local utils = require'core.utils'

    -- Prioritize snippets and field names.
    local lsp_sort = function(entry1, entry2)
        local kind = types.lsp.CompletionItemKind
        local a, b = entry1:get_kind(), entry2:get_kind()

        -- Text fields are least important.
        a = a == kind.Text and 100 or a
        b = b == kind.Text and 100 or b

        if a ~= b then
            if a == kind.Snippet then return true end
            if b == kind.Snippet then return false end

            if a == kind.Field then return true end
            if b == kind.Field then return false end

            local diff = a - b
            if diff < 0 then return true
            elseif diff > 0 then return false end
        end
    end

    cmp.setup {
        completion = { completeopt = 'menu,menuone,noinsert' },
        confirmation = {
            -- comma and parens won't trigger completion.
            get_commit_characters = function(commit_chars)
                return vim.tbl_filter(function(char)
                    return char ~= ',' and char ~= '('
                end, commit_chars)
            end
        },
        -- Use lspkind icons for completion menu.
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = lspkind.presets.default[vim_item.kind] .. "  " .. vim_item.kind
                vim_item.menu = ({
                    buffer = '[Buffer]',
                    nvim_lsp = '[LSP]',
                    luasnip = '[LuaSnip]',
                    nvim_lua = '[Lua]',
                    vsnip = '[Snip]',
                    latex_symbols = '[Latex]',
                })[entry.source.name]
                return vim_item
            end
        },
        snippet = {
            expand = function(args)
                vim.fn['vsnip#anonymous'](args.body)
            end,
        },
        preselect = cmp.PreselectMode.None,
        sorting = {
            priority_weight = 2,
            comparators = {
                compare.offset,
                compare.exact,
                compare.score,
                lsp_sort,
                compare.sort_text,
                compare.length,
                compare.order,
            }
        },
        mapping = {
            ['<Tab>'] = utils.fn.cmp_select_next,
            ['<S-Tab>'] = utils.fn.cmp_select_prev,
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close()
            -- <CR> is handled by nvim-autopairs.
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'vsnip' }
        },
        autocomplete = true;
        min_length = 0, -- allow for 'from package import _' in Python
    }
end
