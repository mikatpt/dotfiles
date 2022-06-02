return function()
    local ok, alpha = pcall(require, 'alpha')
    if not ok then
        return
    end
    local dashboard = require('alpha.themes.dashboard')
    local function button(sc, txt, keybind)
        local b = dashboard.button(sc, txt, keybind, {})
        b.opts.hl = 'String'
        return b
    end

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
    dashboard.section.header.opts = {
        hl = 'Function',
        position = 'center',
    }
    dashboard.section.buttons.val = {
        button('CTL n', '" Open Tree', ':NvimTreeToggle<CR>'),
        button('SPC o', '  Recently opened', ':lua require"telescope.builtin".oldfiles()<CR>'),
        button('CTL p', '  Git files', ':silent! lua require"telescope.builtin".git_files()<CR>'),
        button(
            'SPC r',
            '  Find word',
            ':lua require"telescope.builtin".grep_string({ search = vim.fn.input("Grep For > ")})<CR>'
        ),
        button(
            'SPC z',
            '  Config files',
            ':lua require"telescope.builtin".git_files({cwd = "$HOME/.config/nvim" })<CR>'
        ),
    }
    dashboard.config.opts.noautocmd = true
    alpha.setup(dashboard.config)
end
