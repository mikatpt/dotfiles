return function()
    local dap = require('dap')
    local extpath = require('core.utils').os.home .. '/.vscode-server/extensions/vadimcn.vscode-lldb-1.6.10/'
    local codelldb = extpath .. 'adapter/codelldb'
    local liblldb = extpath .. 'lldb/lib/liblldb.so'

    -- defining this here in case dependency loading order is funky.
    dap.adapters.lldb = require('rust-tools.dap').get_codelldb_adapter(codelldb, liblldb)

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
            cmd = { vim.fn.stdpath('data') .. '/lsp_servers/rust/rust-analyzer' },
            on_attach = require('modules.lspconfig.on-attach'),
            settings = {
                ['rust-analyzer'] = {
                    checkOnSave = { command = 'clippy' },
                    experimental = { procAttrMacros = true },
                    procMacro = { enable = true },
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
