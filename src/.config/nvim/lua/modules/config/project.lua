return function()
    require('project_nvim').setup({
        patterns = { '.git' },
        detection_methods = { 'lsp', 'pattern' },
    })
end
