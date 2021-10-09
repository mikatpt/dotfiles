return function()
    require('indent_blankline').setup({
        filetype_exclude = {
            'terminal',
            'NvimTree',
            'Trouble',
            'lspinfo',
            'dashboard',
        },
        show_first_indent_level = false,
        show_end_of_line = false,
        use_treesitter = true,
        show_current_context = true,
        context_highlight_list = { 'Comment' },
        context_patterns = {
            'declaration',
            'expression',
            'pattern',
            'primary_expression',
            'statement',
            'switch_body',
            'class',
            'function',
            'method',
            '^if',
            '^for',
            '^while',
            '^object',
            '^table',
            'block',
            'arguments',
        },
    })
end
