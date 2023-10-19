return function()
    require('ibl').setup({
        exclude = {
            filetypes = {
                'terminal',
                'NvimTree',
                'Trouble',
                'lspinfo',
                'dashboard',
            },
        },
        scope = {
            show_start = false,
            show_end = false,
            show_exact_scope = true,
        },
    })
end
