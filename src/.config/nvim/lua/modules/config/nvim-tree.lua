return function()
    -- Git's too slow at work
    local not_darwin = vim.loop.os_uname().sysname ~= 'Darwin'

    local nvim_tree = require('nvim-tree')
    if nvim_tree.setup_called then
        return
    end

    require('nvim-web-devicons').setup()
    nvim_tree.setup({
        on_attach = function(bufnr)
            local api = require('nvim-tree.api')
            local function opts(desc)
                return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            api.config.mappings.default_on_attach(bufnr)
            vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
            vim.keymap.del('n', '<C-k>', { buffer = bufnr })
        end,
        hijack_cursor = false,
        auto_reload_on_write = true,
        disable_netrw = false,
        hijack_netrw = true,
        hijack_unnamed_buffer_when_opening = true,
        root_dirs = {},
        prefer_startup_root = false,
        sync_root_with_cwd = false,
        reload_on_bufenter = false,
        respect_buf_cwd = true,
        select_prompts = false,
        sort = {
            sorter = 'name',
            folders_first = true,
            files_first = false,
        },
        view = {
            adaptive_size = false,
            centralize_selection = false,
            width = 30,
            side = 'left',
            preserve_window_proportions = false,
            number = false,
            relativenumber = false,
            signcolumn = 'yes',
            cursorline = true,
            debounce_delay = 15,
            float = {
                enable = false,
                quit_on_focus_loss = true,
                open_win_config = {
                    relative = 'editor',
                    border = 'rounded',
                    width = 30,
                    height = 30,
                    row = 1,
                    col = 1,
                },
            },
        },
        renderer = {
            highlight_git = not_darwin,
            full_name = false,
            highlight_opened_files = 'none',
            icons = {
                web_devicons = {
                    file = {
                        enable = true,
                        color = true,
                    },
                    folder = {
                        enable = false,
                        color = true,
                    },
                },
                git_placement = 'before',
                modified_placement = 'after',
                diagnostics_placement = 'signcolumn',
                bookmarks_placement = 'signcolumn',
                padding = ' ',
                symlink_arrow = ' ➛ ',
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true,
                    modified = true,
                    diagnostics = true,
                    bookmarks = true,
                },
                glyphs = {
                    default = '',
                    symlink = '',
                    bookmark = '󰆤',
                    modified = '●',
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
            add_trailing = false,
            group_empty = false,
            root_folder_label = ':~:s?$?/..?',
            indent_width = 2,
            highlight_diagnostics = false,
            highlight_modified = 'none',
            highlight_bookmarks = 'none',
            highlight_clipboard = 'name',
            indent_markers = {
                enable = false,
                inline_arrows = true,
                icons = {
                    corner = '└',
                    edge = '│',
                    item = '│',
                    bottom = '─',
                    none = ' ',
                },
            },
        },
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        update_focused_file = {
            enable = true,
            update_root = true,
            ignore_list = { 'toggleterm', 'term' },
        },
        system_open = {
            cmd = '',
            args = {},
        },
        git = {
            enable = not_darwin,
            ignore = true,
            show_on_dirs = true,
            timeout = 500,
            show_on_open_dirs = true,
            disable_for_dirs = {},
            cygwin_support = false,
        },
        diagnostics = {
            enable = not_darwin,
            show_on_dirs = false,
            debounce_delay = 50,
            icons = {
                hint = '',
                info = '',
                warning = '',
                error = '',
            },
            show_on_open_dirs = true,
            severity = {
                min = vim.diagnostic.severity.HINT,
                max = vim.diagnostic.severity.ERROR,
            },
        },
        modified = {
            enable = false,
            show_on_dirs = true,
            show_on_open_dirs = true,
        },
        filters = {
            custom = { '\\.git$', '\\.cache$' },
            exclude = { '.gitconfig', '.gitignore' },
            dotfiles = false,
            git_ignored = true,
            git_clean = false,
            no_buffer = false,
        },
        live_filter = {
            prefix = '[FILTER]: ',
            always_show_folders = true,
        },
        filesystem_watchers = {
            enable = true,
            debounce_delay = 50,
            ignore_dirs = {},
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
                eject = true,
                resize_window = true,
                window_picker = {
                    enable = true,
                    picker = 'default',
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
        tab = {
            sync = {
                open = false,
                close = false,
                ignore = {},
            },
        },
        notify = {
            threshold = vim.log.levels.INFO,
            absolute_path = true,
        },
        help = {
            sort_by = 'key',
        },
        ui = {
            confirm = {
                remove = true,
                trash = true,
                default_yes = false,
            },
        },
        experimental = {},
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

        ignore_buf_on_tab_change = {},
        sort_by = 'name',
    })
end
