return function()
    require('rust-tools').setup({
        tools = {
            hover_actions = {
                border = 'single',
                auto_focus = false,
            },
            inlay_hints = {
                highlight = 'TSText',
            },
        },
        server = {
            on_attach = require('modules.lspconfig.on-attach'),
        },
    })
end
