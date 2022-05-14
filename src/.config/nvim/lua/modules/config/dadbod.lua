return function()
    local utils = require('core.utils')

    vim.g.db_ui_save_location = utils.os.config .. '/.env.dbs'
    vim.g.db_ui_winwidth = 40
    vim.g.db_ui_auto_execute_table_helpers = 1
    vim.g.db_ui_table_helpers = {
        postgresql = {
            List = 'select * from {table} limit 100',
        },
    }

    vim.cmd('autocmd FileType dbui nmap <buffer><C-J> <C-W><S-W>')
    vim.cmd('autocmd FileType dbui nmap <buffer><C-K> <C-W>w')
    vim.cmd('autocmd FileType dbui nmap <buffer><C-V> <Plug>(DBUI_SelectLineVsplit)')
end
