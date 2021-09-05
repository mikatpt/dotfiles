return function(client, bufnr)
    vim.opt.omnifunc = 'v:lua.vim.lsp.omnifunc'

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

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

    -- Automatic func signatures
    require('lsp_signature').on_attach({ doc_lines = 2, use_lspsaga = true })

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { noremap=true, silent=true }

    -- Format without saving
    buf_set_keymap('c', 'wf', 'noautocmd w', { noremap = true })

    -- Jump to definition
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua require"modules.lspconfig.handlers".implementation()<CR>', opts)
    buf_set_keymap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    -- When glepnir feels better, we can start using these again
    -- buf_set_keymap('n', 'gr', ':Lspsaga lsp_finder')
    -- buf_set_keymap('n', 'gp', ':Lspsaga preview_definition')

    -- Actions
    buf_set_keymap('n', '<leader>rn', ':Lspsaga rename<CR>', opts)
    buf_set_keymap('n', '<leader>s', '<cmd>lua vim.lsp.buf.formatting_sync(nil, 1000)<CR>', opts)
    buf_set_keymap('n', '<space>ca', ':Lspsaga code_action<CR>', opts)
    buf_set_keymap('v', '<space>ca', ':<C-U>Lspsaga range_code_action<CR>', opts)
    buf_set_keymap('n', '<C-F>', '<CMD>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
    buf_set_keymap('n', '<C-E>', '<CMD>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)

    -- Diagnostics
    buf_set_keymap('n', 'm', ':Lspsaga hover_doc<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '<leader>q', '<cmd>TroubleToggle lsp_document_diagnostics<CR>', opts)
    buf_set_keymap('n', '<leader>Q', '<cmd>TroubleToggle lsp_workspace_diagnostics<CR>', opts)
    buf_set_keymap('n', '[d', ':Lspsaga diagnostic_jump_prev<CR>', opts)
    buf_set_keymap('n', ']d', ':Lspsaga diagnostic_jump_next<CR>', opts)

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
