return function()
    require('quarto').setup({
        lspFeatures = {
            languages = { 'python' },
            chunks = 'all',
            diagnostics = {
                enabled = true,
                triggers = { 'BufWritePost' },
            },
            completion = {
                enabled = true,
            },
        },
        codeRunner = {
            enabled = true,
            default_method = 'molten',
        },
    })
end
