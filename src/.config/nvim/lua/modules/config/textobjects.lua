return function()
    require('nvim-treesitter-textobjects').setup({
        select = {
            lookahead = true,
            selection_modes = {
                ['@parameter.outer'] = 'v',
                ['@function.outer'] = 'V',
                ['@class.outer'] = '<c-v>',
            },
            include_surrounding_whitespace = false,
        },
        move = { set_jumps = true },
        swap = {},
    })

    local select = require('nvim-treesitter-textobjects.select')
    local move = require('nvim-treesitter-textobjects.move')
    local swap = require('nvim-treesitter-textobjects.swap')

    for keys, query in pairs({
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
    }) do
        vim.keymap.set({ 'x', 'o' }, keys, function()
            select.select_textobject(query, 'textobjects')
        end)
    end

    local mv = { 'n', 'x', 'o' }
    vim.keymap.set(mv, ']n', function() move.goto_next_start('@function.outer', 'textobjects') end)
    vim.keymap.set(mv, ']]', function() move.goto_next_start('@class.outer', 'textobjects') end)
    vim.keymap.set(mv, ']N', function() move.goto_next_end('@function.outer', 'textobjects') end)
    vim.keymap.set(mv, '][', function() move.goto_next_end('@class.outer', 'textobjects') end)
    vim.keymap.set(mv, '[n', function() move.goto_previous_start('@function.outer', 'textobjects') end)
    vim.keymap.set(mv, '[[', function() move.goto_previous_start('@class.outer', 'textobjects') end)
    vim.keymap.set(mv, '[]', function() move.goto_previous_end('@class.outer', 'textobjects') end)

    vim.keymap.set('n', '<leader>a', function() swap.swap_next('@parameter.inner') end)
    vim.keymap.set('n', '<leader>A', function() swap.swap_previous('@parameter.inner') end)
end
