return function()
    local alpha = require('alpha')
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
    }
    dashboard.config.opts.noautocmd = true
    alpha.setup(dashboard.config)
    -- vim.g.dashboard_custom_section = {
    --     a = {
    --         description = { '" Open Tree                            CTL n' },
    --         command = ':NvimTreeToggle'
    --     },
    --     b = {
    --         description = { '  Recently opened                      SPC o' },
    --         command = 'lua require"telescope.builtin".oldfiles()',
    --     },
    --     c = {
    --         description = { '  Git files                            CTL p' },
    --         command = 'silent! lua require"telescope.builtin".git_files()',
    --     },
    --     d = {
    --         description = { '  Find word                            SPC r' },
    --         command = 'lua require"telescope.builtin".grep_string({ search = vim.fn.input("Grep For > ")})',
    --     },
    --     e = {
    --         description = { '  Config files                         SPC z' },
    --         command = 'lua require"telescope.builtin".git_files({cwd = "$HOME/.config/nvim" })',
    --     }
    -- }
end
