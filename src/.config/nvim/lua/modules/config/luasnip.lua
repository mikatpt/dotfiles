return function()
    require('luasnip.loaders.from_vscode').lazy_load({ paths = '~/.config/nvim/snippets/' })
end
