return function()
    require'rust-tools'.setup({
        hover_actions = {
            border = 'single',
            auto_focus = false
        },
        server = {
            on_attach = require('modules.lspconfig.on-attach'),
        }
    })
end
