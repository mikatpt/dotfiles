return function()
    local pre_hook = nil
    if not vim.g.vscode then
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
    end
    require('Comment').setup({
        pre_hook = pre_hook,
        padding = true,
        sticky = true,
        post_hook = function() end,
    })
end
