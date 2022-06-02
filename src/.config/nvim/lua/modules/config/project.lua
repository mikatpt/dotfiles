return function()
    require('project_nvim').setup({
        patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'package.json', 'Cargo.toml' },
    })
end
