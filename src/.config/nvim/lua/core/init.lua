-- feline.nvim and project.nvim still call the deprecated vim.lsp.buf_get_clients.
-- Both are effectively unmaintained; shim silently to vim.lsp.get_clients rather
-- than let the noisy deprecation warning fire on every buffer.
vim.lsp.buf_get_clients = function(bufnr)
    return vim.lsp.get_clients({ bufnr = bufnr or 0 })
end

if vim.g.vscode then
    require('core.options')
    require('core.map')
    return
end
require('core.options')
require('core.plug_opts')
require('core.map')
require('core.autocmds')
