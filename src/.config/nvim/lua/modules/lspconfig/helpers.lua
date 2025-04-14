local M = {}

-- This needs to be a global id, otherwise each buffer will recreate the group and wipe the previous
-- buffers.
local format_group = vim.api.nvim_create_augroup('mikatpt_Format', { clear = true })

M.on_attach = function(client, bufnr)
    -- Nicer hover menus for builtin lsp methods
    require('lspsaga').setup({
        diagnostic = {
            show_code_action = true,
            jump_num_shortcut = true,
            extend_relatedInformation = true,
            text_hl_follow = true,
        },
        ui = {
            theme = 'round',
            border = 'rounded',
            winblend = 0,
            expand = '',
            collapse = '',
            preview = ' ',
            code_action = '💡',
            diagnostic = '🐞 ',
            incoming = ' ',
            outgoing = ' ',
            colors = {
                normal_bg = '',
                title_bg = '',
            },
            kind = {},
        },
        lightbulb = {
            enable = false,
            enable_in_insert = false,
            sign = false,
            cache_code_action = true,
            update_time = 150,
            sign_priority = 20,
            virtual_text = true,
        },
        rename = {
            keys = {
                exec = '<CR>',
            },
            in_select = false,
        },
        symbol_in_winbar = {
            enable = false,
            separator = '  ',
            hide_keyword = true,
            show_file = true,
            folder_level = 1,
        },
    })

    -- Automatic function signatures
    require('lsp_signature').on_attach({
        doc_lines = 2,
        use_lspsaga = true,
        hint_enable = false,
        toggle_key = '<C-E>',
    })

    -- Mappings
    require('modules.lspconfig.lsp-map').attach_mappings(client, bufnr)

    -- only one may format
    client.server_capabilities.documentFormattingProvider = client.name == 'null-ls'

    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = format_group,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end,
        })
    end

    if client.name == 'tsserver' then
        local ts_utils = require('nvim-lsp-ts-utils')
        ts_utils.setup({
            auto_inlay_hints = false,
        })
        ts_utils.setup_client(client)
        -- This is behaving weird and I don't like it.
        -- vim.api.nvim_create_autocmd('BufWritePre', {
        --     group = format_group,
        --     buffer = bufnr,
        --     command = 'TSLspOrganizeSync',
        --     desc = 'Organizes imports on save',
        -- })
    elseif client.name == 'rust_analyzer' then
        local ns = vim.api.nvim_create_namespace('rust_analyzer')
        vim.diagnostic.config({ virtual_text = { min = 'Error' } }, ns)
    end
end

M.set_capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Auto-complete options
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { 'documentation', 'detail', 'additionalTextEdits' },
    }

    -- Set default column signs
    local sn = {
        Error = { ' ', vim.diagnostic.severity.ERROR },
        Warn = { ' ', vim.diagnostic.severity.WARN },
        Info = { ' ', vim.diagnostic.severity.INFO },
        Hint = { '', vim.diagnostic.severity.HINT },
    }

    local signs = {
        text = {},
        linehl = {},
        numhl = {},
    }

    for type, metadata in pairs(sn) do
        local symbol = metadata[1]
        local id = metadata[2]
        local hl = 'DiagnosticSign' .. type

        signs.text[id] = symbol
        signs.numhl[id] = hl
    end

    -- Don't update diagnostics while typing
    vim.diagnostic.config({
        underline = true,
        virtual_text = { min = 'Warning' },
        signs = signs,
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'single' },
    })

    return capabilities
end

-- Order of priority: Defined root patterns, then git root, then cwd.
M.get_root = function(root_files)
    local util = require('lspconfig').util
    return function(fname)
        return util.root_pattern(unpack(root_files))(fname)
            or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
            or vim.fs.dirname(fname)
    end
end

-- Telescope's lsp_implementations always brings up a preview menu, which can be annoying.
-- If there's only one result, we'll just use the built-in lsp function.
local custom_impl = function(err, result, ctx)
    local ft = vim.api.nvim_get_option_value('filetype', { buf = ctx.bufnr })
    local no_impls_err = 'ERROR: No implementations for this item!'

    if result == nil then
        result = {}
        err = no_impls_err
    end

    if ft == 'go' or ft == 'rust' then
        -- Do not include implementations from mocks or test files in go and rust.
        -- We do two checks to make sure we don't open telescope if not necessary
        local new_result = vim.tbl_filter(function(v)
            local uri = ft == 'go' and v.uri or v.targetUri
            return not string.find(uri, 'mock') and not string.find(uri, 'test') and not string.find(uri, 'circuits')
        end, result)

        if #new_result > 0 then
            result = new_result
        end

        if #new_result > 1 then
            require('telescope.builtin').lsp_implementations({
                layout_strategy = 'vertical',
                file_ignore_patterns = { '*mock*/*', '**/*mock*', '*test*/*', '**/*test*' },
            })
            return
        end
    else
        if type(result) == 'table' and #result > 1 then
            require('telescope.builtin').lsp_implementations({ layout_strategy = 'vertical' })
            return
        end
    end

    if result == nil or (type(result) == 'table' and #result == 0) then
        err = no_impls_err
    end

    vim.lsp.handlers['textDocument/implementation'](err, result, ctx)
    vim.cmd([[normal! zz]])
end

M.implementation = function()
    local params = vim.lsp.util.make_position_params(0, 'utf-8')

    vim.lsp.buf_request(0, 'textDocument/implementation', params, custom_impl)
end

return M
