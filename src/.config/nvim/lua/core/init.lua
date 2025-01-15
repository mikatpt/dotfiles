if vim.g.vscode then
    require('core.options')
    require('core.map')
    return
end
require('core.options')
require('core.plug_opts')
require('core.map')
require('core.autocmds')
