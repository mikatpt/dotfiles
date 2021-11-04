vim.cmd('runtime! config/**/*.vim')

require('modules')
require('core.options')
require('core.keybindings')
require('core.utils').fn.dashboard_startup()
