return function()
    local cmp = require'cmp'
    local compare = require'cmp.config.compare'
    local lspkind = require'lspkind'
    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end

    cmp.setup {
        completion = { completeopt = 'menu,menuone,noinsert' },
        confirmation = {
            -- comma won't commit.
            get_commit_characters = function(commit_chars)
                return vim.tbl_filter(function(char)
                    return char ~= ',' and char ~= '('
                end, commit_chars)
            end
        },
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
                compare.kind,
                compare.sort_text,
                compare.length,
                compare.order,
            }
        },
        mapping = {
            ['<Tab>'] = function(fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(t('<C-N>'), 'n')
                elseif vim.fn['vsnip#available']() == 1 then
                    vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
                else
                    fallback()
                end
            end,
            ['<S-Tab>'] = function(_, fallback)
                if vim.fn.pumvisible() == 1 then
                    vim.fn.feedkeys(t('<C-P>'), 'n')
                elseif vim.fn['vsnip#available']() == 1 then
                    vim.fn.feedkeys(t('<Plug>(vsnip-jump-prev)'), '')
                else
                    fallback()
                end
            end,
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
