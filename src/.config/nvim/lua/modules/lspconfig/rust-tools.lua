return function()
    local dap = require('dap')
    local extpath = vim.loop.os_homedir() .. '/.vscode-server/extensions/vadimcn.vscode-lldb-1.7.4//'
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
                auto = true,
                only_current_line = true,
                show_parameter_hints = true,
                parameter_hints_prefix = '<- ',
                other_hints_prefix = '=> ',
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = 'Comment',
            },
        },
        server = {
            cmd = { vim.fn.stdpath('data') .. '/mason/bin/rust-analyzer' },
            on_attach = require('modules.lspconfig.helpers').on_attach,
            settings = {
                ['rust-analyzer'] = {
                    checkOnSave = { command = 'clippy' },
                    diagnostics = { disabled = { 'type-mismatch' } },
                    experimental = { procAttrMacros = true },
                    inlayHints = {
                        lifetimeElisionHints = { enable = true },
                        reborrowHints = { enable = true },
                    },
                    procMacro = {
                        enable = true,
                        ignored = {
                            ['async-trait'] = { 'async_trait' },
                        },
                    },
                },
            },
        },
        dap = {
            adapter = require('rust-tools.dap').get_codelldb_adapter(codelldb, liblldb),
        },
    })
end
