return function()
    local ok, alpha = pcall(require, 'alpha')
    if not ok then
        return
    end
    local dashboard = require('alpha.themes.dashboard')
    dashboard.section.header.val = {
        '',
        ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
        ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
        ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
        ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
        ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
        ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
        '',
    }
    dashboard.section.buttons.val = {
        dashboard.button('CTL n', '" Open Tree', ':NvimTreeToggle<CR>', {}),
        dashboard.button('SPC o', '  Recently opened', ':lua require"telescope.builtin".oldfiles()<CR>', {}),
        dashboard.button('CTL p', '  Git files', ':silent! lua require"telescope.builtin".git_files()<CR>', {}),
        dashboard.button(
            'SPC r',
            '  Find word',
            ':lua require"telescope.builtin".grep_string({ search = vim.fn.input("Grep For > ")})<CR>',
            {}
        ),
        dashboard.button(
            'SPC z',
            '  Config files',
            ':lua require"telescope.builtin".git_files({cwd = "$HOME/.config/nvim" })<CR>',
            {}
        ),
    }
    dashboard.config.opts.noautocmd = true
    alpha.setup(dashboard.config)
end
