return function()
    vim.g.db_ui_save_location = vim.fn.stdpath('config') .. '/.env.dbs'
    vim.g.db_ui_winwidth = 40
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_table_helpers = {
        postgresql = {
            List = 'select * from {table} limit 100',
        },
    }

    local id = vim.api.nvim_create_augroup('dadbod_bindings', { clear = true })
    vim.api.nvim_create_autocmd('FileType', {
        group = id,
        pattern = { 'dbui' },
        callback = function()
            vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><S-W>', { silent = true })
            vim.api.nvim_set_keymap('n', '<C-K>', '<C-W>w', { silent = true })
            vim.api.nvim_set_keymap('n', '<C-V>', '<Plug>(DBUI_SelectLineVsplit)', { silent = true })
        end,
    })
end
