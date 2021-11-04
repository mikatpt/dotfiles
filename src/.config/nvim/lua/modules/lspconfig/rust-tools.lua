return function()
    require('rust-tools').setup({
        tools = {
            hover_actions = {
                border = 'single',
                auto_focus = false,
            },
            inlay_hints = {
                highlight = 'Comment',
            },
        },
        server = {
            on_attach = require('modules.lspconfig.on-attach'),
            settings = {
                ['rust-analyzer'] = {
                    checkOnSave = { command = 'clippy' },
                },
            },
        },
    })
end
