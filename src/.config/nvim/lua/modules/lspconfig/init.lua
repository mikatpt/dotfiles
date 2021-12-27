return function()
    local lspconfig = require('lspconfig')
    local util = lspconfig.util
    local lspinstaller = require('nvim-lsp-installer')
    local on_attach = require('modules.lspconfig.on-attach')

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    vim.lsp.set_log_level('error')

    -- Auto-complete options
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    -- Don't update diagnostics while typing
    vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        underline = true,
        virtual_text = { severity_limit = 'Warning' },
        signs = true,
        update_in_insert = false,
        severity_sort = true,
    })

    local function get_root(fname, root_files)
        return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end

    local format_config = require('modules.lspconfig.format')
    local servers = {
        efm = {
            init_options = { documentFormatting = true, codeAction = true },
            root_dir = lspconfig.util.root_pattern({ '.git/', 'Makefile', 'go.mod', 'package.json', 'Cargo.toml' }),
            filetypes = vim.tbl_keys(format_config),
            settings = {
                languages = format_config,
                logFile = vim.fn.stdpath('cache') .. '/efm.log',
                logLevel = vim.log.levels.DEBUG,
            },
            handlers = {
                ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                    underline = true,
                    virtual_text = false,
                    signs = true,
                    update_in_insert = false,
                    severity_sort = true,
                }),
            },
        },
        gopls = {
            root_dir = function(fname)
                return get_root(fname, { 'go.mod', 'Makefile' })
            end,
        },
        jsonls = {
            root_dir = lspconfig.util.root_pattern({ '.git/', 'package.json' }),
            filetypes = { 'json', 'jsonc' },
        },
        sumneko_lua = require('lua-dev').setup(),
        pyright = {
            filetypes = { 'python' },
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
                        diagnosticMode = 'workspace',
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        },
        solargraph = {
            root_dir = function(fname)
                local root_files = { '.solargraph.yml', '.rubocop.yml', '.git/' }
                return get_root(fname, root_files)
            end,
            -- cmd = { 'solargraph', 'stdio' },
            filetypes = { 'ruby' },
        },
        tsserver = {
            root_dir = function(fname)
                local root_files = { 'package.json', 'tsconfig.json', 'yarn.lock', '.git/' }
                return get_root(fname, root_files)
            end,
        },
        yamlls = {
            root_dir = function(fname)
                return get_root(fname, { '.git' })
            end,
            settings = {
                yaml = {
                    customTags = {
                        '!and',
                        '!if',
                        '!not',
                        '!equals',
                        '!or',
                        '!findinmap sequence',
                        '!base64',
                        '!cidr',
                        '!ref',
                        '!sub',
                        '!getatt',
                        '!getazs',
                        '!flatten sequence',
                        '!importvalue',
                        '!select',
                        '!select sequence',
                        '!split',
                        '!join sequence',
                    },
                },
            },
        },
    }

    local function setup_servers()
        local installed = lspinstaller.get_installed_servers()

        for _, server in pairs(installed) do
            local config = servers[server.name]
                or {
                    root_dir = function(fname)
                        return get_root(fname, { '.git/' })
                    end,
                }

            config.capabilities = capabilities
            config.on_attach = on_attach

            server:setup(config)
        end
    end

    setup_servers()
end
