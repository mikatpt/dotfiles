return function()
    vim.g.dashboard_footer_icon = '🐬 '
    vim.g.dashboard_preview_file_height = 12
    vim.g.dashboard_preview_file_width = 80
    vim.g.dashboard_disable_statusline = 1
    vim.g.dashboard_default_executive = 'telescope'
    vim.g.dashboard_custom_section = {
        a = {
            description = { '" Open Tree                            CTL n' },
            command = ':NvimTreeToggle'
        },
        b = {
            description = { '  Recently opened                      SPC o' },
            command = 'lua require"telescope.builtin".oldfiles()',
        },
        c = {
            description = { '  Git files                            CTL p' },
            command = 'silent! lua require"telescope.builtin".git_files()',
        },
        d = {
            description = { '  Find word                            SPC r' },
            command = 'lua require"telescope.builtin".grep_string({ search = vim.fn.input("Grep For > ")})',
        },
        e = {
            description = { '  Config files                         SPC z' },
            command = 'lua require"telescope.builtin".git_files({cwd = "$HOME/.config/nvim" })',
        }
    }

    vim.g.dashboard_custom_header = {
        '',
        '',
        '',
        ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
        ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
        ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
        ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
        ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
        ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
        '',
    }
end

