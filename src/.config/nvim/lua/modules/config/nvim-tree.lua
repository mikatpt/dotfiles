return function()
    -- Git's too slow at work
    local not_darwin = vim.loop.os_uname().sysname ~= 'Darwin'

    local nvim_tree = require('nvim-tree')
    if nvim_tree.setup_called then
        return
    end

    require('nvim-web-devicons').setup()
    nvim_tree.setup({
        disable_netrw = false,
        hijack_netrw = true,
        open_on_setup = false,
        open_on_tab = false,
        hijack_cursor = true,
        diagnostics = {
            enable = true,
            icons = {
                hint = '',
                info = '',
                warning = '',
                error = '',
            },
        },
        update_cwd = true,
        update_focused_file = {
            enable = true,
            update_cwd = true,
            ignore_list = {},
        },
        respect_buf_cwd = true,
        -- configuration options for the system open command (`s` in the tree by default)
        system_open = {
            cmd = nil, -- the command to run this, leaving nil should work in most cases
            args = {}, -- the command arguments as a list
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
end
