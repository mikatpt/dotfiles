return function()
    ---@diagnostic disable: missing-fields
    require('Comment').setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
        padding = true,
        sticky = true,
        post_hook = function() end,
    })
end
