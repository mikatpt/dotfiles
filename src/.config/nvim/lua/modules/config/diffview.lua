return function()
    local actions = require('diffview.config').actions

    require('diffview').setup({
        enhanced_diff_hl = true,
        keymaps = {
            view = {
                ['<leader>d'] = actions.toggle_files,
                ['<leader>rl'] = actions.refresh_files,
            },
            file_panel = {
                ['<leader>d'] = actions.toggle_files,
                ['<leader>rl'] = actions.refresh_files,
            },
            file_history_panel = {
                ['<leader>d'] = actions.toggle_files,
                ['<leader>rl'] = actions.refresh_files,
            },
        },
    })
end
