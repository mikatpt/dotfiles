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

    local luasnip = require('luasnip')

    require('luasnip.loaders.from_vscode').lazy_load({ paths = './snippets' })

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
            format = function(_, vim_item)
                vim_item.kind = (lspkind.presets.default[vim_item.kind] or '') .. '  ' .. vim_item.kind
                return vim_item
            end,
        },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
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
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-Space>'] = cmp.mapping.complete({}),
            ['<C-e>'] = cmp.mapping.close(),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'vim-dadbod-completion' },
            {
                name = 'buffer',
                keyword_length = 10,
                max_item_count = 10,
                -- entry_filter = function(entry, ctx)
                --     return #entry.completion_item.label > 7
                -- end 
            } ,
        },
        autocomplete = true,
        min_length = 0, -- allow for 'from package import _' in Python
    })
end
