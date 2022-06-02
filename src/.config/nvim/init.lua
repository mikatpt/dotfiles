local ok, impatient = pcall(require, 'impatient')
if ok then
    impatient.enable_profile()
end

vim.cmd('runtime! vim_conf/*.vim')
require('core.options')
require('core.map')
pcall(require, 'packer_compiled')

require('modules')
require('core.utils').fn.dashboard_startup()
require('core.utils').fn.auto_close_tree()
