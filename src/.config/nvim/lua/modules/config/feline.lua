return function()
    local lsp = require('feline.providers.lsp')
    local disable_noice = false
    local noice_status = nil
    if not disable_noice then
        noice_status = require('noice').api.status
    end

    local colors = {
        white = '#c0caf5',
        darker_black = '#151621',
        black = '#1A1B26',
        black2 = '#20212c',
        one_bg = '#242530',
        one_bg2 = '#292a35',
        one_bg3 = '#353b45',
        light_grey2 = '#1d1e29',
        grey = '#40486a',
        grey_fg = '#4a5274',
        grey_fg2 = '#4f5779',
        light_grey = '#545c7e',
        red = '#f7768e',
        baby_pink = '#DE8C92',
        pink = '#ff75a0',
        line = '#242530',
        green = '#9ece6a',
        vibrant_green = '#73daca',
        nord_blue = '#80a8fd',
        blue = '#7aa2f7',
        dark_blue = '#000A12',
        yellow = '#e7c787',
        sun = '#EBCB8B',
        purple = '#bb9af7',
        dark_purple = '#9d7cd8',
        teal = '#0db9d7',
        orange = '#ff9e64',
        cyan = '#7dcfff',
        statusline_bg = '#12131A',
        lightbg = '#2B2B39',
        lightbg2 = '#22232e',
        pmenu_bg = '#7aa2f7',
        folder_bg = '#7aa2f7',
    }

    local mode_colors = {
        ['n'] = { 'NORMAL', colors.nord_blue },
        ['no'] = { 'N-PENDING', colors.nord_blue },
        ['i'] = { 'INSERT', colors.dark_purple },
        ['ic'] = { 'INSERT', colors.dark_purple },
        ['t'] = { 'TERMINAL', colors.green },
        ['v'] = { 'VISUAL', colors.sun },
        ['V'] = { 'V-LINE', colors.sun },
        ['\22'] = { 'V-BLOCK', colors.sun },
        ['R'] = { 'REPLACE', colors.orange },
        ['Rv'] = { 'V-REPLACE', colors.orange },
        ['s'] = { 'SELECT', colors.nord_blue },
        ['S'] = { 'S-LINE', colors.nord_blue },
        [''] = { 'S-BLOCK', colors.nord_blue },
        ['c'] = { 'COMMAND', colors.pink },
        ['cv'] = { 'COMMAND', colors.pink },
        ['ce'] = { 'COMMAND', colors.pink },
        ['r'] = { 'PROMPT', colors.teal },
        ['rm'] = { 'MORE', colors.teal },
        ['r?'] = { 'CONFIRM', colors.teal },
        ['!'] = { 'SHELL', colors.green },
    }

    local icon_styles = {
        default = {
            left = '',
            right = ' ',
            main_icon = '  ',
            vi_mode_icon = ' ',
            position_icon = ' ',
        },
        arrow = {
            left = '',
            right = '',
            main_icon = '  ',
            vi_mode_icon = ' ',
            position_icon = ' ',
        },

        block = {
            left = ' ',
            right = ' ',
            main_icon = '   ',
            vi_mode_icon = '  ',
            position_icon = '  ',
        },

        round = {
            left = '',
            right = '',
            main_icon = '  ',
            vi_mode_icon = ' ',
            position_icon = ' ',
        },
        slant = {
            left = ' ',
            right = ' ',
            main_icon = '  ',
            vi_mode_icon = ' ',
            position_icon = ' ',
        },
    }

    local statusline_style = icon_styles['default']

    -- Initialize components
    local components = { active = {}, inactive = {} }
    for _ = 1, 3 do
        table.insert(components.active, {})
    end
    for _ = 1, 2 do
        table.insert(components.inactive, {})
    end

    --[[
        Component format:
            - provider: Displayed icon or string
            - hl: The provider's color (fg) and background color (bg)
            - left_sep/right_sep: Optional divider

        Note: See below for functional examples. These are necessary for any stateful changes,
              like checking buffer names or git branches.
    --]]

    -- Logo
    table.insert(components.active[1], {
        provider = statusline_style.main_icon,
        hl = function()
            return {
                fg = colors.statusline_bg,
                bg = mode_colors[vim.fn.mode()][2],
            }
        end,
    })

    -- Git Branch
    table.insert(components.active[1], {
        provider = function()
            local git_branch = ''

            -- Use gitsigns to check branch name.
            local gs_dict = vim.b.gitsigns_status_dict
            if gs_dict then
                git_branch = (gs_dict.head and #gs_dict.head > 0 and gs_dict.head) or git_branch
            end
            return (git_branch ~= '' and '   ' .. git_branch) or git_branch
        end,
        hl = { gf = colors.dark_purple, bg = colors.statusline_bg },
        left_sep = function()
            local background = colors.light_grey2
            if vim.b.gitsigns_status_dict then
                background = colors.statusline_bg
            end

            return {
                str = statusline_style.right,
                hl = { fg = mode_colors[vim.fn.mode()][2], bg = background },
            }
        end,
        right_sep = function()
            local s = ''
            if vim.b.gitsigns_status_dict then
                s = '  '
            end
            return { str = s, hl = { fg = colors.statusline_bg, bg = colors.statusline_bg } }
        end,
    })

    local function get_icon()
        local filename = vim.fn.expand('%:t')
        local extension = vim.fn.expand('%:e')
        local icon = require('nvim-web-devicons').get_icon(filename, extension)
        local filetype = vim.bo.filetype

        if filename == 'NvimTree' then
            icon = ' '
        elseif filetype == 'alpha' then
            icon = ''
            filename = 'Dashboard'
        elseif filetype == 'proto' then
            icon = ''
        elseif filetype == 'Trouble' then
            icon = ''
        end

        if icon == nil then
            icon = '  '
        end

        return icon
    end

    local function filename_component(status)
        local background = colors.statusline_bg
        if status == 'active' then
            background = colors.light_grey2
        end
        return {
            left_sep = function()
                if status ~= 'active' then
                    return { str = '', hl = { fg = colors.statusline_bg, bg = colors.statusline_bg } }
                end

                local icon = statusline_style.right .. ' '
                if not vim.b.gitsigns_status_dict then
                    icon = ' '
                end

                local colo = colors.statusline_bg
                if not vim.b.gitsigns_status_dict then
                    colo = colors.light_grey2
                end

                return { str = icon, hl = { fg = colo, bg = colors.light_grey2 } }
            end,
            provider = function()
                local filename = vim.fn.expand('%:t')
                local icon = get_icon()

                local info_icon = ''
                if vim.bo.readonly == true then
                    info_icon = ' '
                elseif vim.bo.modifiable and vim.bo.modified then
                    info_icon = ' '
                end

                return icon .. ' ' .. filename .. ' ' .. info_icon .. ' '
            end,
            right_sep = function()
                return { str = '', hl = { fg = background, bg = background } }
            end,
            hl = {
                fg = colors.white,
                bg = background,
            },
        }
    end

    -- File icon, name, edited status
    table.insert(components.active[1], filename_component('active'))

    -- Padding
    table.insert(components.active[1], {
        provider = statusline_style.right,
        hl = { fg = colors.light_grey2, bg = colors.statusline_bg },
    })

    -- Diagnostics
    table.insert(components.active[1], {
        provider = 'diagnostic_errors',
        enabled = function()
            return lsp.diagnostics_exist('Error')
        end,
        hl = { fg = colors.red, bg = colors.statusline_bg },
        icon = '  ',
    })

    table.insert(components.active[1], {
        provider = 'diagnostic_warnings',
        enabled = function()
            return lsp.diagnostics_exist('Warn')
        end,
        hl = { fg = colors.yellow, bg = colors.statusline_bg },
        icon = '  ',
    })

    table.insert(components.active[1], {
        provider = 'diagnostic_hints',
        enabled = function()
            return lsp.diagnostics_exist('Hint')
        end,
        hl = { fg = colors.nord_blue, bg = colors.statusline_bg },
        icon = '  ',
    })

    table.insert(components.active[1], {
        provider = 'diagnostic_info',
        enabled = function()
            return lsp.diagnostics_exist('Info')
        end,
        hl = { fg = colors.green, bg = colors.statusline_bg },
        icon = '  ',
    })

    local function get_noice_comp(component)
        return function()
            return component.has() and component.get() or ''
        end
    end

    if not disable_noice then
        -- Display mode in statusline since we killed the command line
        table.insert(components.active[1], {
            left_sep = { str = ' ', hl = { bg = colors.statusline_bg, fg = colors.statusline_bg } },
            provider = get_noice_comp(noice_status.mode),
            hl = { fg = colors.white, bg = colors.statusline_bg },
        })

        -- Search info
        table.insert(components.active[1], {
            left_sep = { str = ' ', hl = { bg = colors.statusline_bg, fg = colors.statusline_bg } },
            provider = get_noice_comp(noice_status.search),
            hl = { fg = colors.white, bg = colors.statusline_bg },
        })
        -- Padding
        table.insert(components.active[1], {
            provider = '',
            hl = { fg = colors.statusline_bg, bg = colors.statusline_bg },
        })

        -- Current key command
        table.insert(components.active[3], {
            left_sep = { str = ' ', hl = { bg = colors.statusline_bg, fg = colors.statusline_bg } },
            provider = get_noice_comp(noice_status.command),
            hl = { fg = colors.white, bg = colors.statusline_bg },
        })
    end

    -- Line:cursor position
    table.insert(components.active[3], {
        provider = function()
            return string.format('%d:%d', unpack(vim.api.nvim_win_get_cursor(0)))
        end,
        hl = { fg = colors.white, bg = colors.statusline_bg },
        left_sep = { str = ' ', hl = { bg = colors.statusline_bg, fg = colors.statusline_bg } },
    })

    table.insert(components.active[3], {
        provider = 'file_encoding',
        hl = { fg = colors.white, bg = colors.statusline_bg },
        left_sep = { str = ' ', hl = { bg = colors.statusline_bg } },
    })

    -- Diffs
    table.insert(components.active[3], {
        provider = 'git_diff_added',
        short_provider = '',
        hl = {
            fg = colors.green,
            bg = colors.statusline_bg,
        },
        icon = '  ',
    })

    table.insert(components.active[3], {
        provider = 'git_diff_changed',
        short_provider = '',
        hl = {
            fg = colors.yellow,
            bg = colors.statusline_bg,
        },
        icon = '  ',
    })

    table.insert(components.active[3], {
        provider = 'git_diff_removed',
        short_provider = '',
        hl = {
            fg = colors.red,
            bg = colors.statusline_bg,
        },
        icon = '  ',
    })

    -- LSP client name
    table.insert(components.active[3], {
        provider = function()
            if next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil then
                local clients = vim.lsp.get_clients()

                local name = 'lsp'
                for _, client in ipairs(clients) do
                    if
                        type(client) == 'table' and (client.name:lower() == 'efm' or client.name:lower() == 'eslint')
                    then
                        goto continue
                    end

                    local buf_ft = vim.api.nvim_get_option_value('filetype', { buf = 0 })
                    local filetypes = client.config.filetypes ---@diagnostic disable-line
                    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                        name = type(client) == 'table' and client.name:lower() or name
                        break
                    end

                    ::continue::
                end

                if name == 'rust_analyzer' then
                    name = 'rust'
                elseif name == 'golangci_lint_ls' or name == 'gopls' then
                    name = 'go'
                end

                return '    ' .. name
            end
            return ''
        end,
        short_provider = function()
            if next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil then
                return '    '
            end
            return ''
        end,
        hl = { fg = colors.purple, bg = colors.statusline_bg },
    })

    -- Vim mode
    table.insert(components.active[3], {
        provider = statusline_style.vi_mode_icon,
        short_provider = '',
        hl = function()
            return {
                fg = colors.statusline_bg,
                bg = mode_colors[vim.fn.mode()][2],
            }
        end,
        left_sep = function()
            return {
                str = '  ' .. statusline_style.left,
                hl = { fg = mode_colors[vim.fn.mode()][2], bg = colors.statusline_bg },
            }
        end,
        right_sep = function()
            return {
                str = ' ' .. mode_colors[vim.fn.mode()][1] .. ' ',
                hl = { fg = mode_colors[vim.fn.mode()][2], bg = colors.statusline_bg },
            }
        end,
    })

    -- File Line %
    table.insert(components.active[3], {
        provider = statusline_style.position_icon,
        short_provider = '',
        left_sep = { str = ' ' .. statusline_style.left, hl = { fg = colors.vibrant_green, bg = colors.statusline_bg } },
        hl = {
            fg = colors.black,
            bg = colors.vibrant_green,
        },
    })

    table.insert(components.active[3], {
        provider = function()
            local current_line = vim.fn.line('.')
            local total_line = vim.fn.line('$')

            if current_line == 1 then
                return ' TOP '
            elseif current_line == vim.fn.line('$') then
                return ' BOT '
            end
            local result, _ = math.modf((current_line / total_line) * 100)
            return ' ' .. result .. '%% '
        end,

        hl = {
            fg = colors.vibrant_green,
            bg = colors.statusline_bg,
        },
    })

    -- Inactive components appear on the dashboard, nvim-tree, etc.
    table.insert(components.inactive[1], {
        provider = statusline_style.main_icon,
        hl = { fg = colors.statusline_bg, bg = colors.dark_purple },

        right_sep = {
            str = icon_styles.round.right,
            hl = {
                fg = colors.dark_purple,
                bg = colors.statusline_bg,
            },
        },
    })

    table.insert(components.inactive[1], {
        provider = icon_styles.round.right,
        hl = {
            fg = colors.statusline_bg,
            bg = colors.statusline_bg,
        },
    })

    table.insert(components.inactive[1], filename_component('inactive'))

    local config = {
        colors = { fg = colors.white, bg = colors.statusline_bg },
        components = components,
        force_inactive = {
            filetypes = {
                'NvimTree',
                'dashboard',
            },
            buftypes = { 'terminal' },
            bufnames = {},
        },
        disable = {
            filetypes = {
                'Trouble',
                'dbui',
                'packer',
                'startify',
                'fugitive',
                'fugitiveblame',
                'dapui_scopes',
                'dapui_breakpoints',
                'dapui_stacks',
                'dapui_watches',
            },
        },
    }

    require('fidget').setup({
        progress = {
            ignore = { 'null-ls' },
        },
    })
    require('feline').setup(config)
end
