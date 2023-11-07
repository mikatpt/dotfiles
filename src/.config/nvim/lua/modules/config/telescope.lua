return function()
    require('telescope').setup({
        defaults = {
            vimgrep_arguments = {
                'rg',
                '--hidden',
                '--color=never',
                '--no-heading',
                '--with-filename',
                '--line-number',
                '--column',
                '--smart-case',
            },
            prompt_prefix = '> ',
            selection_caret = '> ',
            entry_prefix = '  ',
            initial_mode = 'insert',
            selection_strategy = 'reset',
            sorting_strategy = 'descending',
            layout_strategy = 'horizontal',
            layout_config = {
                horizontal = {
                    mirror = false,
                },
                vertical = {
                    mirror = false,
                },
            },
            mappings = {
                n = { ['q'] = require('telescope.actions').close },
            },
            file_sorter = require('telescope.sorters').get_fuzzy_file,
            file_ignore_patterns = { 'node_modules/', '.gitignore', '.git/' },
            generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
            winblend = 0,
            border = {},
            borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
            color_devicons = true,
            use_less = true,
            path_display = {},
            set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
            file_previewer = require('telescope.previewers').vim_buffer_cat.new,
            grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
            qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

            -- Developer configurations: Not meant for general override
            -- buffer_previewer_maker = require('telescope.previewers').buffer_previewer_maker,
            buffer_previewer_maker = function(filepath, bufnr, opts)
                opts = opts or {}

                filepath = vim.fn.expand(filepath, nil, false)
                vim.loop.fs_stat(filepath, function(_, stat) ---@diagnostic disable-line
                    if not stat then
                        return
                    end
                    local max_size = 100 * 1024
                    if stat.size > max_size then
                        local cmd = { 'head', '-c', max_size, filepath }
                        require('telescope.previewers.utils').job_maker(cmd, bufnr, opts)
                    else
                        require('telescope.previewers').buffer_previewer_maker(filepath, bufnr, opts)
                    end
                end)
            end,
        },
        extensions = {
            fzf = {
                fuzzy = true,
                override_generic_sorter = true,
                override_file_sorter = true,
                case_mode = 'smart_case',
            },
        },
    })
    require('telescope').load_extension('fzf')
end
