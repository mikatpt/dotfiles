return function(client, bufnr)
    vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Enable completion triggered by <c-x><c-o>
    -- What is omnifunc and do we need it? Investigate later.
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- saga gives us nicer hover menus for the builtin lsp functions
    require('lspsaga').init_lsp_saga({
        rename_action_keys = { quit = '<ESC>', exec = '<CR>' },
        rename_prompt_prefix = 'Rename ➤',
        code_action_prompt = {
            enable = true,
            sign = false,
            sign_priority = 20,
            virtual_text = false,
        },
    })

    -- Automatic function signatures
    require('lsp_signature').on_attach({ doc_lines = 2, use_lspsaga = true })

    -- Mappings
    require'modules.lspconfig.lspbindings'.attach_mappings(bufnr)

    -- So that the only client with format capabilities is efm
    if client.name ~= 'efm' then
        client.resolved_capabilities.document_formatting = false
    end

    if client.resolved_capabilities.document_formatting then
        vim.cmd([[
            augroup Format
                autocmd! * <buffer>
                autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
            augroup END
        ]])
    end
end
