return function()
    require('todo-comments').setup({
        sign_priority = 8,

        keywords = {
            FIX = {
                icon = ' ',
                color = 'error', -- can be a hex color, or a named color (see below)
                alt = { 'FIX', 'FIXME', 'BUG', 'FIXIT', 'ISSUE', 'FAIL' },
            },
            TODO = { icon = ' ', color = 'info' },
            HACK = { icon = ' ', color = 'warning' },
            WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
            PERF = { icon = ' ', color = 'hint', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
            NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        },
        merge_keywords = false,
        highlight = {
            before = '',
            keyword = 'fg',
            after = 'fg',
            pattern = [[.*<(KEYWORDS)(\([^\)]*\))?:]],
            comments_only = true,
            max_line_len = 400,
            exclude = {},
        },
        colors = {
            error = { 'LspDiagnosticsDefaultError', 'ErrorMsg', '#DC2626' },
            warning = { 'LspDiagnosticsDefaultWarning', 'WarningMsg', '#FBBF24' },
            info = { 'Title', '#2563EB' },
            hint = { 'LspDiagnosticsDefaultHint', '#10B981' },
            default = { 'Identifier', '#7C3AED' },
        },
        search = {
            command = 'rg',
            args = {
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--hidden',
            },
            pattern = [[\b(KEYWORDS):]], -- ripgrep regex
        },
    })
end
