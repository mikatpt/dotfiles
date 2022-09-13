return function()
    require('project_nvim').setup({
        patterns = { '.git', '_darcs', '.hg', '.bzr', 'package.json', 'Cargo.toml' },
        detection_methods = { 'lsp', 'pattern' },
    })
end
