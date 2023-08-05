return function()
    require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        padding = true,
        sticky = true,
        ignore = '',
        mappings = {
            basic = true,
            extra = true,
        },
        toggler = {
            line = 'gcc',
            block = 'gbc',
        },
        opleader = {
            line = 'gc',
            block = 'gb',
        },
        extra = {
            above = 'gcO',
            below = 'gco',
            eol = 'gcA',
        },
        post_hook = function() end,
    })
end
