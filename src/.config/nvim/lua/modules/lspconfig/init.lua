return function()
    local lspconfig = require('lspconfig')
    local lspinstall = require('lspinstall')
    local on_attach = require('modules.lspconfig.on-attach')

    require('modules.lspconfig.ui').symbols_override()
    require('modules.lspconfig.ui').disable_virtual_text()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            update_in_insert = false
        }
    )

    vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
        if err ~= nil or result == nil then
            return
        end
        if not vim.api.nvim_buf_get_option(bufnr, "modified") then
            local view = vim.fn.winsaveview()
            vim.lsp.util.apply_text_edits(result, bufnr)
            vim.fn.winrestview(view)
            if bufnr == vim.api.nvim_get_current_buf() then
                vim.api.nvim_command("noautocmd :update")
            end
        end
    end

    local format_config = require('modules.lspconfig.format')
    local servers = {
        efm = {
            init_options = { documentFormatting = true, codeAction = true },
            root_dir = lspconfig.util.root_pattern({ '.git/', '.' }),
            filetypes = vim.tbl_keys(format_config),
            settings = {
                languages = format_config,
                -- logFile = '/Users/m.chen@coinbase.com/.cache/nvim/efm.log',
                -- logFile = '/home/mikatpt/.cache/nvim/efm.log',
                logLevel = 1,
            }
        },
        lua = {
            settings = {
                Lua = {
                    diagnostics = { globals = { 'vim' } },
                    completion = { keywordSnippet = 'Both' },
                    runtime = {
                        version = 'LuaJIT',
                        path = vim.split(package.path, ';'),
                    },
                    workspace = {
                        library = vim.list_extend(
                            { [vim.fn.expand('$VIMRUNTIME/lua')] = true },
                            {}
                        ),
                    },
                },
            },
        },
    }

    -- Setup servers
    local function setup_servers()
        lspinstall.setup()
        local installed = lspinstall.installed_servers()
        for _, server in pairs(installed) do
            local config = servers[server]
                or { root_dir = lspconfig.util.root_pattern({ '.git/', '.' }) }
            config.capabilities = capabilities
            config.on_attach = on_attach
            lspconfig[server].setup(config)
        end
    end

    setup_servers()
end
