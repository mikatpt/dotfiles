return function()
    local utils = require('core.utils')
    local imap = utils.keybinds.imap
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true

    local opts = { silent = true }
    vim.cmd([[inoremap <silent><expr> <C-Y> copilot#Accept("\<CR>")]])
    imap('<C-b>', '<Plug>(copilot-previous)', opts)
    imap('<C-f>', '<Plug>(copilot-next)', opts)
    imap('<C-\\>', '<Plug>(copilot-dismiss)', opts)
    imap('<C-o>', '<Plug>(copilot-suggest)', opts)
end
