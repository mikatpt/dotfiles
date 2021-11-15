return function()
    require('rust-tools').setup({
        tools = {
            hover_actions = {
                border = 'single',
                auto_focus = false,
            },
            inlay_hints = {
                only_current_line = true,
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
            handlers = {
                ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                    underline = true,
                    virtual_text = { severity_limit = 'Error' },
                    signs = true,
                    update_in_insert = false,
                    severity_sort = true,
                }),
            },
        },
    })
end
