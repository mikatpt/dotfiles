---@diagnostic disable: missing-parameter, unused-local
-- stylua: ignore start
local M = {}

local keybinds = require('core.utils').keybinds
local nnoremap = keybinds.nnoremap
local vnoremap = keybinds.vnoremap
local cnoremap = keybinds.cnoremap

M.attach_mappings = function(client, bufnr)
    -- Format without saving
    cnoremap('wf', 'noautocmd w', { silent = false })

    -- Custom telescope find_implementation. Ignores mocks and tests in go.
    nnoremap('gi', function() require('modules.lspconfig.helpers').implementation() end)

    -- Jump to definition
    nnoremap('gd', function() require('telescope.builtin').lsp_definitions() end)
    nnoremap('gr', function() require('telescope.builtin').lsp_references() end)
    nnoremap('gD', function() vim.lsp.buf.declaration() end)
    nnoremap('gp', function() require('lspsaga.definition'):init(1, 1) end)

    -- Actions
    nnoremap('<leader>rn', function() require('lspsaga.rename'):lsp_rename() end)
    nnoremap('<space>ca',  function() require('lspsaga.codeaction'):code_action() end)
    vnoremap('<space>ca',  function() require('lspsaga.codeaction'):code_action() end)

    -- Diagnostics
    if type(client) == 'table' and client.name == 'rust_analyzer' then
        nnoremap('m',       function() require('core.utils').fn.rust_tools_hover() end)
    elseif type(client) == 'table' and client.name == 'null-ls' then
        -- don't attach hover actions to null-ls
    else
        nnoremap('m',       function() vim.lsp.buf.hover() end)
    end

    -- lspsaga has a really nice diagnostic window that it doesn't use for line diagnostics, manual
    -- implementation here. pray that glepnir does not break it.
    nnoremap(
        '<leader>e',
        function()
            require('lspsaga.diagnostic'):goto_next()
            -- not sure if we want this one
            -- require('lspsaga.diagnostic.show'):show_diagnostics({ line = true, args = {'++unfocus'}})
        end
    )
    nnoremap('[d',          function() require('lspsaga.diagnostic'):goto_prev() end)
    nnoremap(']d',          function() require('lspsaga.diagnostic'):goto_next() end)

    -- Debugging
    nnoremap('<F5>',        function() require('dapui').open({})require('dap').continue() end)
    nnoremap('<F10>',       function() require('dap').step_over({}) end)
    nnoremap('<F11>',       function() require('dap').step_into() end)
    nnoremap('<F12>',       function() require('dap').step_out() end)
    nnoremap('<C-Y>',       function() require('dapui').toggle({}) end)
    nnoremap('<leader>d',   function() require('dapui').eval() end)
    vnoremap('<leader>d',   function() require('dapui').eval() end)
    nnoremap('<C-B>',       function() require('dap').toggle_breakpoint() end)
end

return M
