require('impatient').enable_profile()

vim.cmd('runtime! vim_conf/*.vim')
require('core.options')
require('core.map')
require('packer_compiled')

require('modules.config').dashboard()

require('modules')
require('core.utils').fn.dashboard_startup()
require('core.utils').fn.auto_close_tree()
