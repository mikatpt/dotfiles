-- stylua: ignore start
return function()
    local cmp = require('cmp')
    local types = require('cmp.types')
    local compare = require('cmp.config.compare')
    local lspkind = require('lspkind')

    -- Prioritize snippets and field names.
    local lsp_sort = function(entry1, entry2)
        local kind = types.lsp.CompletionItemKind
        local a, b = entry1:get_kind(), entry2:get_kind()

        if a ~= b then
            if a == kind.Field then return true end
            if b == kind.Field then return false end

            if a == kind.Method then return true end
            if b == kind.Method then return false end

            if a == kind.Snippet then return true end
            if b == kind.Snippet then return false end
        end
    end

    cmp.setup({
        completion = { completeopt = 'menu,menuone,noinsert' },
        confirmation = {
            -- comma and parens won't trigger completion.
            get_commit_characters = function(commit_chars)
                return vim.tbl_filter(function(char)
                    return char ~= ',' and char ~= '(' and char ~= '.'
                end, commit_chars)
            end,
        },
        -- Use lspkind icons for completion menu.
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = lspkind.presets.default[vim_item.kind] .. '  ' .. vim_item.kind
                vim_item.menu = ({
                    buffer = '[Buffer]',
                    nvim_lsp = '[LSP]',
                    luasnip = '[LuaSnip]',
                    nvim_lua = '[Lua]',
                    vsnip = '[Snip]',
                    latex_symbols = '[Latex]',
                })[entry.source.name]
                return vim_item
            end,
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
                compare.exact,
                lsp_sort,
                compare.offset,
                compare.score,
                compare.sort_text,
                compare.length,
                compare.order,
            },
        },
        mapping = {
            ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
            { name = 'buffer', keyword_length = 7 },
        },
        autocomplete = true,
        min_length = 0, -- allow for 'from package import _' in Python
    })
end
