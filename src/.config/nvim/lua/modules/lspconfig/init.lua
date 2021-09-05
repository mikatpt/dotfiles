return function()
    local lspconfig = require('lspconfig')
    local lspinstall = require('lspinstall')
    local on_attach = require('modules.lspconfig.on-attach')
    local utils = require('core.utils')

    require('modules.lspconfig.ui').symbols_override()

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Auto-complete options
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    -- Don't update diagnostics while typing
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            virtual_text = true,
            signs = true,
            update_in_insert = false
        }
    )

    local format_config = require('modules.lspconfig.format')

    local lua_lsp_root = utils.os.cache..'/lspconfig/sumneko_lua/lua-language-server'
    local lua_lsp_binary = lua_lsp_root.."/bin/"..utils.os.name.."/lua-language-server"
    local servers = {
        efm = {
            init_options = { documentFormatting = true, codeAction = true },
            root_dir = lspconfig.util.root_pattern({ '.git/', '.' }),
            filetypes = vim.tbl_keys(format_config),
            settings = {
                languages = format_config,
                -- logFile = utils.os.cache..'/efm.log',
                -- logLevel = 1,
            }
        },
        lua = {
            cmd = { lua_lsp_binary, '-E', lua_lsp_root..'/main.lua' },
            settings = {
                Lua = {
                    diagnostics = { globals = { 'vim' } },
                    completion = { keywordSnippet = 'Both' },
                    runtime = {
                        version = 'LuaJIT',
                        path = vim.split(package.path, ';'),
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file("", true)
                    },
                    telemetry = { enable = false },
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
