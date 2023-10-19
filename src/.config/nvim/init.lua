local ok, impatient = pcall(require, 'impatient')
if ok and impatient then
    impatient.enable_profile()
end

require('core')
require('modules')
