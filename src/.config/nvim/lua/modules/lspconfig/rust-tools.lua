return function()
    local dap = require('dap')
    local extpath = vim.loop.os_homedir() .. '/.vscode-server/extensions/vadimcn.vscode-lldb-1.6.10/'
    local codelldb = extpath .. 'adapter/codelldb'
    local liblldb = extpath .. 'lldb/lib/liblldb.so'

    dap.adapters.lldb = require('rust-tools.dap').get_codelldb_adapter(codelldb, liblldb)

    -- Rust tools handles client capabilities.
    require('rust-tools').setup({
        tools = {
            hover_actions = {
                border = 'single',
                auto_focus = false,
            },
            inlay_hints = {
                only_current_line = false,
                highlight = 'Comment',
            },
        },
        server = {
            cmd = { vim.fn.stdpath('data') .. '/lsp_servers/rust/rust-analyzer' },
            on_attach = require('modules.lspconfig.helpers').on_attach,
            settings = {
                ['rust-analyzer'] = {
                    checkOnSave = { command = 'clippy' },
                    experimental = { procAttrMacros = true },
                    procMacro = {
                        enable = true,
                        ignored = {
                            ['async-trait'] = { 'async_trait' },
                        },
                    },
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
        dap = {
            adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb, liblldb),
        },
    })
end
