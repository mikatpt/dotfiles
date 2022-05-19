local M = {}

M.attach_mappings = function(bufnr)
    local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end

    local opts = { noremap = true, silent = true }

    -- Format without saving
    buf_set_keymap('c', 'wf', 'noautocmd w', { noremap = true })

    -- Custom telescope find_implementation. Ignores mocks and tests in go.
    buf_set_keymap('n', 'gi', "<CMD>lua require'modules.lspconfig.helpers'.implementation()<CR>", opts)

    -- Jump to definition
    buf_set_keymap('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gp', ':Lspsaga preview_definition<CR>', opts)

    -- Actions
    buf_set_keymap('n', '<leader>rn', ':Lspsaga rename<CR>', opts)
    buf_set_keymap('n', '<space>ca', ':Lspsaga code_action<CR>', opts)
    buf_set_keymap('v', '<space>ca', ':<C-U>Lspsaga range_code_action<CR>', opts)
    buf_set_keymap('n', '<C-W><C-F>', '<CMD>lua require("lspsaga.action").smart_scroll_with_saga(1)<CR>', opts)
    buf_set_keymap('n', '<C-W><C-E>', '<CMD>lua require("lspsaga.action").smart_scroll_with_saga(-1)<CR>', opts)

    -- Diagnostics
    buf_set_keymap('n', 'm', ':lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<leader>e', '<cmd>Lspsaga show_line_diagnostics<CR>', opts)
    buf_set_keymap('n', '[d', ':Lspsaga diagnostic_jump_prev<CR>', opts)
    buf_set_keymap('n', ']d', ':Lspsaga diagnostic_jump_next<CR>', opts)
end

return M
