return function()
    local lspconfig = require('lspconfig')
    local util = lspconfig.util
    local lspinstall = require('lspinstall')
    local on_attach = require('modules.lspconfig.on-attach')
    local coq = require('coq')
    vim.defer_fn(
        function()
            vim.o.completeopt = 'menu,preview,noinsert,menuone'
        end, 1000
    )

    require('modules.lspconfig.ui').symbols_override()

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Auto-complete options
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    -- Don't update diagnostics while typing
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = false,
            virtual_text = true,
            signs = true,
            update_in_insert = false,
            severity_sort = true,
        }
    )

    local format_config = require('modules.lspconfig.format')
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
        lua = require('lua-dev').setup(),
        python = {
            filetypes = { "python" },
            root_dir = function(fname)
                local root_files = {
                    'pyproject.toml',
                    'setup.py',
                    'setup.cfg',
                    'requirements.txt',
                    'Pipfile',
                    'pyrightconfig.json',
                }
                return util.root_pattern(unpack(root_files))(fname)
                    or util.find_git_ancestor(fname) or util.path.dirname(fname)
            end,
            settings = {
                python = {
                    analysis = {
                        autoSearchPaths = true,
                        diagnosticMode = "workspace",
                        useLibraryCodeForTypes = true
                    }
                }
            },
        },
        rust = {
            root_dir = util.root_pattern('Cargo.toml', 'rust-project.json', '.git/', '.'),
            settings = {
                ['rust-analyzer'] = {
                    checkOnSave = { command = 'clippy' }
                }
            }

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
            config = coq.lsp_ensure_capabilities(config)
            -- table.insert(config, coq.lsp_ensure_capabilities())
            lspconfig[server].setup(config)
        end
    end

    setup_servers()

    -- Auto setup servers again after :LspInstall <server>
    lspinstall.post_install_hook = function()
        setup_servers()
        vim.cmd("bufdo e")
    end
end
