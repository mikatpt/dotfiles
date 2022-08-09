-- stylua: ignore start
local M = {}

local bind = function(bufnr, mode, outer_opts)
    outer_opts = outer_opts or { silent = true, buffer = bufnr }
    return function(lhs, rhs, opts)
        opts = vim.tbl_extend('force', outer_opts, opts or {})
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

M.attach_mappings = function(client, bufnr)
    -- :h map-listing
    -- local nmap = bind(bufnr, 'n', { silent = true, remap = true })
    -- local inoremap = bind(bufnr, 'i')
    -- local icnoremap = bind(bufnr, '!')
    local nnoremap = bind(bufnr, 'n')
    local vnoremap = bind(bufnr, 'v')
    local cnoremap = bind(bufnr, 'c')

    -- Format without saving
    cnoremap('wf', 'noautocmd w')

    -- Custom telescope find_implementation. Ignores mocks and tests in go.
    nnoremap('gi', function() require('modules.lspconfig.helpers').implementation() end)

    -- Jump to definition
    nnoremap('gd', function() require('telescope.builtin').lsp_definitions() end)
    nnoremap('gr', function() require('telescope.builtin').lsp_references() end)
    nnoremap('gD', function() vim.lsp.buf.declaration() end)
    nnoremap('gp', function() require('lspsaga.provider').preview_definition(500) end)

    -- Actions
    nnoremap('<leader>rn', function() require('lspsaga.rename').rename() end)
    nnoremap('<space>ca', function() require('lspsaga.codeaction').code_action() end)
    vnoremap('<space>ca', function() require('lspsaga.codeaction').code_action() end)
    nnoremap('<C-W><C-F>', function() require('lspsaga.action').smart_scroll_with_saga(1) end)
    nnoremap('<C-W><C-E>', function() require('lspsaga.action').smart_scroll_with_saga(-1) end)


    -- Diagnostics
    if client.name == 'rust_analyzer' then
        nnoremap('m', function() require('rust-tools').hover_actions.hover_actions() end)
    else
        nnoremap('m', function() vim.lsp.buf.hover() end)
    end
    nnoremap('<leader>e', function() require('lspsaga.diagnostic').show_line_diagnostics() end)
    nnoremap('[d', function() require('lspsaga.diagnostic').navigate('prev')() end)
    nnoremap(']d', function() require('lspsaga.diagnostic').navigate('next')() end)
end

return M
