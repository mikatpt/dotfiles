return function()
    require('ts_context_commentstring').setup({
        enable_autocmd = false,
        commentary_integration = {},
        config = {},
        languages = { 'ts', 'tsx', 'js', 'jsx' },
    })
end
