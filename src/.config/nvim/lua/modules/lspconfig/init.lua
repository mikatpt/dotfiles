return function()
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

    local util = require('lspconfig').util
    -- Order of priority: Defined root patterns, then git root, then cwd.
    local function get_root(root_files)
        return function(fname)
            return util.root_pattern(unpack(root_files))(fname)
                or util.find_git_ancestor(fname)
                or util.path.dirname(fname)
        end
    end

    local format_config = require('modules.lspconfig.format')
    local pyroots = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json' }

    local servers = {
        efm = {
            init_options = { documentFormatting = true, codeAction = true },
            root_dir = get_root({ '.git/', 'Makefile', 'go.mod', 'package.json', 'Cargo.toml' }),
            filetypes = vim.tbl_keys(format_config),
            settings = {
                languages = format_config,
            },
            handlers = {
                -- No need to see formatting lints, they are very distracting
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
            root_dir = get_root({ 'go.mod', 'Makefile' }),
        },
        jsonls = {
            root_dir = get_root({ '.git/', 'package.json' }),
            filetypes = { 'json', 'jsonc' },
        },
        sumneko_lua = require('lua-dev').setup(),
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
        solargraph = {
            root_dir = get_root({ '.solargraph.yml', '.rubocop.yml' }),
            -- cmd = { 'solargraph', 'stdio' },
            filetypes = { 'ruby' },
        },
        tsserver = {
            root_dir = get_root({ 'package.json', 'tsconfig.json', 'yarn.lock' }),
        },
        rust_analyzer = {
            root_dir = get_root({ 'Cargo.toml', 'rust-project.json' }),
        },
        yamlls = {
            root_dir = get_root({ '.git/' }),
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
        local installed = require('nvim-lsp-installer').get_installed_servers()

        for _, server in pairs(installed) do
            if server.name == 'rust_analyzer' then goto CONTINUE end
            local config = servers[server.name] or { root_dir = get_root({ '.git/' }) }

            config.capabilities = capabilities
            config.on_attach = require('modules.lspconfig.on-attach')

            server:setup(config)
            ::CONTINUE::
        end
    end
    require('modules.config').rust_tools()
    require('lspconfig').protols.setup({})

    setup_servers()
end
