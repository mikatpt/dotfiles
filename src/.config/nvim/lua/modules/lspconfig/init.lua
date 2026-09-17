return function()
    local helpers = require('modules.lspconfig.helpers')
    local capabilities = helpers.set_capabilities()

    vim.lsp.log.set_level('error')

    -- Several servers (pyright, ts_ls, jsonls, yamlls, ...) are Node-based. mise only
    -- puts `node` on PATH inside directories where it's pinned, so launching nvim
    -- outside that tree makes those servers die silently with exit code 127.
    if vim.fn.executable('node') == 0 then
        vim.notify(
            "nvim's PATH has no `node` — Node-based LSP servers (pyright, ts_ls, jsonls, ...) will fail to start. "
                .. 'Check `mise current` in the directory nvim was launched from.',
            vim.log.levels.ERROR
        )
    end

    local pyroots = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json' }

    local schemas = require('schemastore').json.schemas()
    -- ledger schema
    table.insert(schemas, {
        -- fileMatch = { '**/postingrules/definitions/**/*.json' },
        -- url = 'file://' .. (vim.loop.os_homedir() .. '/src/ledger/pkg/postingrules/postingrules_schema.json'),
    })

    -- Defaults applied to every server via `vim.lsp.enable`.
    vim.lsp.config('*', {
        capabilities = capabilities,
        on_attach = helpers.on_attach,
    })

    local servers = {
        bashls = {
            root_markers = { '.git' },
            filetypes = { 'sh', 'zsh', 'bash' },
        },
        cssls = {
            root_markers = { 'package.json', '.git' },
        },
        gopls = {
            root_markers = { 'go.mod', 'go.work', '.git' },
            filetypes = { 'go', 'gomod' },
            settings = {
                gopls = {
                    buildFlags = { '-tags=all_tests,integration' },
                    completeUnimported = true,
                    semanticTokens = true,
                    analyses = {
                        deprecated = true,
                        ST1000 = false,
                        ST1003 = false,
                        ST1020 = false,
                        ST1021 = false,
                        ST1022 = false,
                        comment = false,
                        package = false,
                    },
                    staticcheck = true,
                },
            },
        },
        jsonls = {
            filetypes = { 'json', 'jsonc' },
            settings = {
                json = {
                    schemas = schemas,
                    validate = { enable = true },
                },
            },
        },
        pyright = {
            filetypes = { 'python' },
            root_markers = vim.list_extend(vim.deepcopy(pyroots), { '.git' }),
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
            root_markers = { '.solargraph.yml', '.rubocop.yml', '.git' },
            cmd = { vim.loop.os_homedir() .. '/.local/share/mise/shims/solargraph', 'stdio' },
            filetypes = { 'ruby' },
        },
        lua_ls = {
            settings = {
                Lua = {
                    telemetry = { enable = false },
                    runtime = { version = 'LuaJIT' },
                    workspace = { checkThirdParty = false },
                    diagnostics = {
                        disable = { 'unused-function' },
                    },
                },
            },
        },
        ts_ls = {
            root_markers = { 'package.json', 'tsconfig.json', 'yarn.lock', '.git' },
        },
        yamlls = {
            root_markers = { '.git' },
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

    for name, cfg in pairs(servers) do
        -- Packaged configs (nvim-lspconfig's lsp/*.lua) can ship their own on_attach
        -- (e.g. pyright's). vim.lsp.config merges with tbl_deep_extend, which doesn't
        -- chain functions, so that on_attach would otherwise silently replace ours.
        local packaged_on_attach = vim.lsp.config[name] and vim.lsp.config[name].on_attach
        if packaged_on_attach then
            cfg.on_attach = function(client, bufnr)
                helpers.on_attach(client, bufnr)
                packaged_on_attach(client, bufnr)
            end
        end
        vim.lsp.config(name, cfg)
    end

    require('modules.config').mason()
    require('mason-lspconfig').setup({
        ensure_installed = vim.list_extend(vim.tbl_keys(servers), { 'html', 'rust_analyzer', 'bashls' }),
        -- rust_analyzer is driven by rust-tools.nvim, not vim.lsp.enable.
        automatic_enable = { exclude = { 'rust_analyzer' } },
    })

    for _, method in ipairs({ 'textDocument/diagnostic', 'workspace/diagnostic' }) do
        local default_handler = vim.lsp.handlers[method]
        vim.lsp.handlers[method] = function(err, result, context)
            if err ~= nil and err.code == -32802 then
                return
            end
            return default_handler(err, result, context)
        end
    end

    -- Treesitter already conceals markdown entity_reference nodes (&nbsp; etc.) as
    -- real characters, but open_floating_preview hardcodes concealcursor = '', which
    -- reveals the raw entity on whichever line the cursor sits on. Keep concealing.
    local default_open_float = vim.lsp.util.open_floating_preview
    vim.lsp.util.open_floating_preview = function(contents, syntax, opts)
        local floating_bufnr, winid = default_open_float(contents, syntax, opts)
        if winid and vim.api.nvim_win_is_valid(winid) then
            vim.wo[winid].concealcursor = 'n'
        end
        return floating_bufnr, winid
    end
end
