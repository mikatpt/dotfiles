local function large_file_disable_plugins()
    vim.defer_fn(function()
        vim.notify('mikatpt: turning off heavy plugins for file > 100KB', vim.log.levels.WARN)
    end, 50)
    if vim.fn.exists(':TSBufDisable') then
        local ts_plugs = {
            'autotag',
            'highlight',
            'indent',
            'refactor.smart_rename',
            'refactor.highlight_current_scope',
            'refactor.highlight_definitions',
            'refactor.navigation',
            'incremental_selection',
        }
        for _, plugin in pairs(ts_plugs) do
            vim.cmd(':TSBufDisable ' .. plugin)
        end
    end

    -- vim.cmd('syntax clear')
    -- vim.cmd('syntax off')
    vim.bo.undofile = false
end

local function fix_large_file_perf()
    local group_id = vim.api.nvim_create_augroup('LargeFileDisabling', { clear = true })
    vim.api.nvim_create_autocmd('BufReadPost', {
        group = group_id,
        callback = function()
            if vim.fn.getfsize(vim.fn.expand('%', nil, nil)) > 100 * 1024 and not vim.b.__fix_large_file_perf_ran then
                vim.b.__fix_large_file_perf_ran = true
                large_file_disable_plugins()
            end
        end,
    })
end

local function auto_close_tree()
    local au_group_id = vim.api.nvim_create_augroup('AutoCloseNvimTree', { clear = true })

    local cb = function()
        local ft = vim.bo.filetype
        if _G.auto_close_called or ft == 'NvimTree' or ft == 'TelescopePrompt' or ft == '' then
            return
        end

        _G.auto_close_called = true
        vim.defer_fn(function()
            vim.api.nvim_create_autocmd('BufEnter', {
                command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
                nested = true,
            })
        end, 1000)
        vim.api.nvim_del_augroup_by_id(au_group_id)
    end

    vim.api.nvim_create_autocmd('BufEnter', {
        group = au_group_id,
        callback = cb,
    })
end

fix_large_file_perf()
auto_close_tree()
