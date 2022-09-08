return function()
    local format_config = require('modules.lspconfig.format')
    local helpers = require('modules.lspconfig.helpers')
    local capabilities = helpers.set_capabilities()
    local get_root = helpers.get_root
    local cmd_root = vim.fn.stdpath('data') .. '/lsp_servers'

    vim.lsp.set_log_level('error')

    local pyroots = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json' }

    local format_handlers = {
        ['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = false,
            signs = true,
            update_in_insert = false,
            severity_sort = true,
        }),
        ['window/showMessageRequest'] = function(_, result)
            return result
        end,
    }

    local servers = {
        bashls = {
            root_dir = get_root({ '.git' }),
            filetypes = { 'sh', 'zsh', 'bash' },
        },
        cssls = {
            root_dir = get_root({ 'package.json' }),
        },
        efm = {
            init_options = { documentFormatting = true, codeAction = true },
            root_dir = get_root({ 'go.mod', 'package.json', 'Cargo.toml' }),
            filetypes = vim.tbl_keys(format_config),
            settings = {
                languages = format_config,
                -- logLevel = 1,
            },
            handlers = format_handlers,
        },
        eslint = {
            root_dir = get_root({ 'package.json', '.eslintrc.json' }),
            handlers = format_handlers,
        },
        gopls = {
            root_dir = get_root({ 'go.mod' }),
            filetypes = { 'go', 'gomod' },
            settings = {
                gopls = {
                    ['build.allowModfileModifications'] = true,
                },
            },
        },
        golangci_lint_ls = {
            root_dir = get_root({ 'go.mod', '.golangci.yaml' }),
            init_options = {
                command = { cmd_root .. '/golangci_lint_ls/golangci-lint', 'run', '-D typecheck', '-D structcheck', '--out-format', 'json' }
            },
        },
        jsonls = {
            filetypes = { 'json', 'jsonc' },
            settings = {
                json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = { enable = true },
                },
            },
        },
        pyright = {
            filetypes = { 'python' },
            root_dir = get_root(pyroots),
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
        -- solargraph = {
        --     root_dir = get_root({ '.solargraph.yml', '.rubocop.yml' }),
        --     filetypes = { 'ruby' },
        -- },
        sumneko_lua = require('lua-dev').setup(),
        tsserver = {
            root_dir = get_root({ 'package.json', 'tsconfig.json', 'yarn.lock' }),
            init_options = require('nvim-lsp-ts-utils').init_options,
        },
        yamlls = {
            root_dir = get_root({ '.git' }),
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
        local lspconfig = require('lspconfig')
        local mason_lspconfig = require('mason-lspconfig')
        mason_lspconfig.setup({
            ensure_installed = vim.list_extend(vim.tbl_keys(servers), { 'html', 'rust_analyzer', 'bashls', 'eslint' }),
            automatic_installation = true,
        })
        local installed = mason_lspconfig.get_installed_servers()

        for _, server in pairs(installed) do
            if server == 'rust_analyzer' then goto CONTINUE end
            local config = servers[server] or { root_dir = get_root({ '.git' }) }

            config.capabilities = capabilities
            config.on_attach = helpers.on_attach

            lspconfig[server].setup(config)

            ::CONTINUE::
        end
    end

    setup_servers()
end
