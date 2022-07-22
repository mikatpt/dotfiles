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

auto_close_tree()
