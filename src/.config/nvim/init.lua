local ok, impatient = pcall(require, 'impatient')
if ok and impatient then
    impatient.enable_profile()
end

require('core.options')
require('core.plug_opts')
require('core.map')
pcall(require, 'packer_compiled')

require('modules')
require('core.utils').fn.dashboard_startup()
require('core.autocmds')
