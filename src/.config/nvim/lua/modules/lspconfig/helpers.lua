local M = {}

M.on_attach = function(client, bufnr)
    -- Nicer hover menus for builtin lsp methods
    require('lspsaga').init_lsp_saga({
        rename_action_keys = { quit = '<ESC>', exec = '<CR>' },
        rename_prompt_prefix = 'Rename ➤',
        code_action_prompt = {
            enable = true,
            sign = true,
            sign_priority = 20,
            virtual_text = false,
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
    require('modules.lspconfig.lsp-map').attach_mappings(bufnr)

    -- Only permit EFM to format.
    client.server_capabilities.documentFormattingProvider = client.name == 'efm'

    if client.server_capabilities.documentFormattingProvider then
        vim.cmd([[
            augroup Format
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
            augroup END
        ]])
    end

    if client.name == 'eslint' then
        local group = vim.api.nvim_create_augroup('Eslint', {})
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = group,
            pattern = '<buffer>',
            command = 'EslintFixAll',
            desc = 'Run eslint when saving buffer.',
        })
    elseif client.name == 'tsserver' then
        local ts_utils = require('nvim-lsp-ts-utils')
        ts_utils.setup({
            auto_inlay_hints = false,
        })
        ts_utils.setup_client(client)
    end
end

M.set_capabilities = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

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

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = 'single' }
    )
end

-- Order of priority: Defined root patterns, then git root, then cwd.
M.get_root = function(root_files)
    local util = require('lspconfig').util
    return function(fname)
        return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
    end
end

-- Telescope's lsp_implementations always brings up a preview menu, which can be annoying.
-- If there's only one result, we'll just use the built-in lsp function.
local custom_impl = function(err, result, ctx, config)
    local bufnr = ctx.bufnr
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
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
            return not string.find(uri, 'mock') and not string.find(uri, 'test')
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

    vim.lsp.handlers['textDocument/implementation'](err, result, ctx, config)
    vim.cmd([[normal! zz]])
end

M.implementation = function()
    local params = vim.lsp.util.make_position_params(0, nil)

    vim.lsp.buf_request(0, 'textDocument/implementation', params, custom_impl)
end

M.fix_action = function()
    vim.lsp.buf.code_action({
        apply = true,
        filter = function(action)
            return action.title == 'Fix all auto-fixable problems'
        end,
    })
end

return M
