return function()
    local helpers = require('modules.lspconfig.helpers')
    local capabilities = helpers.set_capabilities()
    local get_root = helpers.get_root
    -- local cmd_root = vim.fn.stdpath('data') .. '/mason/bin'

    vim.lsp.set_log_level('error')

    local pyroots = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json' }

    require('neodev').setup({})
    local servers = {
        bashls = {
            root_dir = get_root({ '.git' }),
            filetypes = { 'sh', 'zsh', 'bash' },
        },
        cssls = {
            root_dir = get_root({ 'package.json' }),
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
        -- Latency here is steadily rising unfortunately.
        -- golangci_lint_ls = {
        --     root_dir = get_root({ 'go.mod', '.golangci.yaml' }),
        --     command = cmd_root .. '/golangci-lint-langserver',
        --     init_options = {
        --         command = { 'golangci-lint', 'run', '--out-format', 'json' }
        --     },
        -- },
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
                        diagnosticMode = 'openFilesOnly',
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        },
        solargraph = {
            root_dir = get_root({ '.solargraph.yml', '.rubocop.yml' }),
            cmd = { vim.loop.os_homedir() .. "/.rbenv/shims/solargraph", "stdio" },
            filetypes = { 'ruby' },
        },
        lua_ls = {
            settings = {
                Lua = {
                    telemetry = { enable = false },
                    workspace = { checkThirdParty = false },
                },
            },
        },
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
        require('modules.config').mason()
        local lspconfig = require('lspconfig')
        local mason_lspconfig = require('mason-lspconfig')
        mason_lspconfig.setup({
            ensure_installed = vim.list_extend(vim.tbl_keys(servers), { 'html', 'rust_analyzer', 'bashls' }),
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
