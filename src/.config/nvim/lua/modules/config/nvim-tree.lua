return function()
    -- Git's too slow at work
    local not_darwin = vim.loop.os_uname().sysname ~= 'Darwin'

    require('nvim-web-devicons').setup()
    require('nvim-tree').setup({
        disable_netrw = false,
        hijack_netrw = true,
        open_on_setup = false,
        -- opens the tree when changing/opening a new tab if the tree wasn't previously opened
        open_on_tab = false,
        -- hijack the cursor in the tree to put it at the start of the filename
        hijack_cursor = true,
        -- updates the root directory of the tree on `DirChanged` (when your run `:cd` usually)
        update_cwd = true,
        diagnostics = {
            enable = true,
            icons = {
                hint = '',
                info = '',
                warning = '',
                error = '',
            },
        },
        update_focused_file = {
            enable = true,
            update_cwd = false,
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
            custom = { '.git', '.cache' },
            exclude = { '.gitconfig', '.gitignore' },
            dotfiles = false,
        },
        git = {
            enable = not_darwin,
            ignore = false,
            timeout = 1000,
        },
        renderer = {
            special_files = { ['README.md'] = 1, Makefile = 1, MAKEFILE = 1 }, -- List of filenames that gets highlighted with NvimTreeSpecialFile
            highlight_git = true,
            icons = {
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true,
                },
                glyphs = {
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
                },
            },
        },
        view = {
            mappings = {
                custom_only = false,
                list = {
                    { key = '<C-k>', action = '' },
                    { key = '<CR>', action = 'edit' },
                },
            },
            -- width of the window, can be either a number (columns) or a string in `%`
            width = 40,
            side = 'left',
        },
    })
    -- We need to apply these autocommands here because they need to run _after_ lazy loading has completed.
    require('core.utils').fn.set_project_root()
    vim.cmd('autocmd WinEnter * lua require("core.utils").fn.set_project_root()')
    vim.cmd('autocmd BufEnter * lua require("core.utils").fn.set_project_root()')
end
