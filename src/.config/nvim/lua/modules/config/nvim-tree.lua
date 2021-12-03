return function()
    local g = vim.g

    g.nvim_tree_git_hl = 1
    g.nvim_tree_special_files = { ['README.md'] = 1, Makefile = 1, MAKEFILE = 1 } -- List of filenames that gets highlighted with NvimTreeSpecialFile
    g.nvim_tree_show_icons = {
        git = 1,
        folders = 1,
        files = 1,
        folder_arrows = 1,
    }
    g.nvim_tree_icons = {
        default = '',
        symlink = '',
        git = {
            unstaged = '',
            staged = '✓',
            unmerged = '',
            renamed = '➜',
            untracked = '★',
            deleted = '',
            ignored = '◌',
        },
        folder = {
            arrow_open = '',
            arrow_closed = '',
            default = '',
            open = '',
            empty = '',
            empty_open = '',
            symlink = '',
            symlink_open = '',
        },
    }

    require('nvim-web-devicons').setup()
    require('nvim-tree').setup({
        disable_netrw = false,
        hijack_netrw = true,
        open_on_setup = true,
        auto_close = true,
        -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
        open_on_tab = false,
        -- hijack the cursor in the tree to put it at the start of the filename
        hijack_cursor = true,
        -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
        update_cwd = true,
        update_to_buf_dir = {
            enable = true,
            auto_open = true,
        },
        diagnostics = {
            enable = true,
            hint = '',
            info = '',
            warning = '',
            error = '',
        },
        update_focused_file = {
            enable = true,
            update_cwd = true,
            ignore_list = {},
        },
        -- configuration options for the system open command (`s` in the tree by default)
        system_open = {
            -- the command to run this, leaving nil should work in most cases
            cmd = nil,
            -- the command arguments as a list
            args = {},
        },
        filters = {
            custom = { '.git/', 'node_modules', '.cache' },
            dotfiles = false,
        },
        git = {
            enable = true,
            ignore = true,
            timeout = 1000,
        },
        view = {
            -- width of the window, can be either a number (columns) or a string in `%`
            width = 40,
            side = 'left',
            auto_resize = true,
        },
    })
end
