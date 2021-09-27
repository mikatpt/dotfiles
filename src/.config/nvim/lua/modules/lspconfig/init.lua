return function()
    local lspconfig = require('lspconfig')
    local util = lspconfig.util
    local lspinstall = require('lspinstall')
    local on_attach = require('modules.lspconfig.on-attach')

    require('modules.lspconfig.ui').symbols_override()

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Auto-complete options
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    -- Don't update diagnostics while typing
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = { severity_limit = 'Warning' },
            signs = true,
            update_in_insert = false,
            severity_sort = true,
        }
    )

    local function get_root(fname, root_files)
        return util.root_pattern(unpack(root_files))(fname)
            or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end

    local format_config = require('modules.lspconfig.format')
    local servers = {
        efm = {
            init_options = { documentFormatting = true, codeAction = true },
            root_dir = function(fname) return get_root(fname, { '.git/' }) end,
            filetypes = vim.tbl_keys(format_config),
            settings = {
                languages = format_config,
                -- logFile = utils.os.cache..'/efm.log',
                -- logLevel = 1,
            },
            handlers = {
                ['textDocument/publishDiagnostics'] = vim.lsp.with(
                    vim.lsp.diagnostic.on_publish_diagnostics, {
                        underline = true,
                        virtual_text = false,
                        signs = true,
                        update_in_insert = false,
                        severity_sort = true,
                    }
                )
            },
        },
        go = {
            root_dir = function(fname) return get_root(fname, { '.git/', '.' }) end,
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
                return get_root(fname, root_files)
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
            root_dir = function(fname)
                local root_files = { 'Cargo.toml', 'rust-project.json', '.git/' }
                return get_root(fname, root_files)
            end,
            settings = {
                ['rust-analyzer'] = {
                    checkOnSave = { command = 'clippy' }
                }
            }
        },
        typescript = {
            root_dir = function(fname)
                local root_files = { 'package.json', 'tsconfig.json', 'yarn.lock', '.git/' }
                return get_root(fname, root_files)
            end,
        },
    }

    -- Setup servers
    local function setup_servers()
        lspinstall.setup()
        local installed = lspinstall.installed_servers()
        for _, server in pairs(installed) do
            local config = servers[server]
                or { root_dir = function(fname) return get_root(fname, { '.git/' }) end }
            config.capabilities = capabilities
            config.on_attach = on_attach
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
