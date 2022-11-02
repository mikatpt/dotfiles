return function()
    -- Git's too slow at work
    local not_darwin = vim.loop.os_uname().sysname ~= 'Darwin'

    local nvim_tree = require('nvim-tree')
    if nvim_tree.setup_called then
        return
    end

    require('nvim-web-devicons').setup()
    nvim_tree.setup({
        open_on_setup = true,
        auto_reload_on_write = true,
        hijack_cursor = true,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = true,
        ignore_buf_on_tab_change = {},
        sort_by = 'name',
        root_dirs = {},
        prefer_startup_root = false,
        sync_root_with_cwd = false,
        reload_on_bufenter = false,
        respect_buf_cwd = true,
        remove_keymaps = {
            '<C-k>',
        },
        view = {
            adaptive_size = false,
            centralize_selection = false,
            width = 40,
            hide_root_folder = false,
            side = 'left',
            preserve_window_proportions = false,
            number = false,
            relativenumber = false,
            signcolumn = 'yes',
            mappings = {
                custom_only = false,
                list = {
                    { key = '<CR>', action = 'edit' },
                },
            },
        },
        renderer = {
            highlight_git = not_darwin,
            full_name = false,
            highlight_opened_files = 'none',
            icons = {
                webdev_colors = true,
                git_placement = 'before',
                padding = ' ',
                symlink_arrow = ' ➛ ',
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true,
                },
                glyphs = {
                    default = '',
                    symlink = '',
                    bookmark = '',
                    folder = {
                        arrow_closed = '',
                        arrow_open = '',
                        default = '',
                        open = '',
                        empty = '',
                        empty_open = '',
                        symlink = '',
                        symlink_open = '',
                    },
                    git = {
                        unstaged = '',
                        staged = '✓',
                        unmerged = '',
                        renamed = '➜',
                        untracked = '★',
                        deleted = '',
                        ignored = '◌',
                    },
                },
            },
            special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'readme.md', 'MAKEFILE' },
            symlink_destination = true,
        },
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        update_focused_file = {
            enable = true,
            update_root = true,
            ignore_list = {},
        },
        ignore_ft_on_setup = {},
        system_open = {
            cmd = '',
            args = {},
        },
        diagnostics = {
            enable = not_darwin,
            show_on_dirs = true,
            debounce_delay = 50,
            icons = {
                hint = '',
                info = '',
                warning = '',
                error = '',
            },
        },
        filters = {
            custom = { '\\.git$', '\\.cache$' },
            exclude = { '.gitconfig', '.gitignore' },
            dotfiles = false,
        },
        filesystem_watchers = {
            enable = true,
            debounce_delay = 50,
        },
        git = {
            enable = not_darwin,
            ignore = true,
            show_on_dirs = true,
            timeout = 500,
        },
        actions = {
            use_system_clipboard = true,
            change_dir = {
                enable = true,
                global = false,
                restrict_above_cwd = false,
            },
            expand_all = {
                max_folder_discovery = 300,
                exclude = {},
            },
            file_popup = {
                open_win_config = {
                    col = 1,
                    row = 1,
                    relative = 'cursor',
                    border = 'shadow',
                    style = 'minimal',
                },
            },
            open_file = {
                quit_on_open = false,
                resize_window = true,
                window_picker = {
                    enable = true,
                    chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
                    exclude = {
                        filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame' },
                        buftype = { 'nofile', 'terminal', 'help' },
                    },
                },
            },
            remove_file = {
                close_window = true,
            },
        },
        trash = {
            cmd = 'gio trash',
            require_confirm = true,
        },
        live_filter = {
            prefix = '[FILTER]: ',
            always_show_folders = true,
        },
        log = {
            enable = false,
            truncate = false,
            types = {
                all = false,
                config = false,
                copy_paste = false,
                dev = false,
                diagnostics = false,
                git = false,
                profile = false,
                watcher = false,
            },
        },
    })
end
