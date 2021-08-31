return function(client, bufnr)
    vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- For function signatures
    require('lsp_signature').on_attach()
    require('lspsaga').init_lsp_saga()

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { noremap=true, silent=true }

    -- Format without saving
    buf_set_keymap('c', 'wf', 'noautocmd w', { noremap = true })

    -- Jump to definition
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

    -- Actions
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<leader>s', '<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>', opts)

    -- Diagnostics
    buf_set_keymap('n', 'm', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>TroubleToggle lsp_document_diagnostics<CR>', opts)
    buf_set_keymap('n', '<leader>Q', '<cmd>TroubleToggle lsp_workspace_diagnostics<CR>', opts)
    -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

    --  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    --  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)

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
