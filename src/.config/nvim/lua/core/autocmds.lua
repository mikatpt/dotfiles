-- use augroups to make this file idempotent!

local function auto_close_tree()
    local group_id = vim.api.nvim_create_augroup('AutoCloseNvimTree', { clear = true })

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
        vim.api.nvim_del_augroup_by_id(group_id)
    end

    vim.api.nvim_create_autocmd('BufEnter', {
        group = group_id,
        callback = cb,
    })
end

local function autokeybinds()
    local group_id = vim.api.nvim_create_augroup('mikatpt_fugitive', { clear = true })
    local opts = { silent = true, noremap = true }
    vim.api.nvim_create_autocmd('Filetype', {
        group = group_id,
        pattern = { 'fugitive' },
        callback = function()
            vim.api.nvim_buf_set_keymap(0, 'n', 'cc', ':Git commit --quiet<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', 'ca', ':Git commit --quiet --amend<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', 'ce', ':Git commit --quiet --amend --no-edit<CR>', opts)
        end,
    })
    vim.api.nvim_create_autocmd('Filetype', {
        group = group_id,
        pattern = { 'lspinfo' },
        callback = function()
            vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':q<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', '<ESC>', ':q<CR>', opts)
        end,
    })
end

local function mouse_events()
    local group_id = vim.api.nvim_create_augroup('mikatpt_mouse_events', { clear = true })

    vim.api.nvim_create_autocmd('FocusLost', { group = group_id, pattern = { '*' }, command = 'set mouse=' })
    vim.api.nvim_create_autocmd('FocusGained', {
        group = group_id,
        pattern = { '*' },
        callback = function()
            vim.defer_fn(function()
                vim.opt.mouse:append({ a = true, r = true })
            end, 50)
        end,
    })
end

-- Extends the Todo syntax group
function UpdateTodoKeywords(word_tbl)
    -- Execute only once per buffer, and only for files which have a filetype.
    if vim.b.__executed_todo_update or vim.bo.filetype == '' then
        return
    end
    vim.b.__executed_todo_update = true

    local keywords = vim.fn.join(word_tbl, ' ')

    local syntax_list = vim.split(vim.fn.execute('syntax list'), '\n')
    local todo_lines = vim.tbl_filter(function(line)
        return string.find(line, '^%a*Todo') ~= nil
    end, syntax_list)

    local todo_groups = vim.tbl_map(function(line)
        return string.gsub(line, ' .*$', '')
    end, todo_lines)

    for _, syntax_group in pairs(todo_groups) do
        vim.cmd('syntax keyword ' .. syntax_group .. ' contained ' .. keywords)
    end
end

local function update_keywords()
    local group_id = vim.api.nvim_create_augroup('mikatpt_update_keywords', { clear = true })
    vim.api.nvim_create_autocmd('BufEnter', {
        group = group_id,
        pattern = { '*' },
        callback = function()
            UpdateTodoKeywords({ 'NOTE', 'FIX', 'FIXIT', 'ISSUE', 'FAIL', 'WARN', 'PERF', 'OPTIM', 'SAFETY', 'INFO' })
        end,
    })
    vim.api.nvim_create_user_command('UpdateToDo', function()
        UpdateTodoKeywords({ 'NOTE', 'FIX', 'FIXIT', 'ISSUE', 'FAIL', 'WARN', 'PERF', 'OPTIM', 'SAFETY', 'INFO' })
    end, {})
end

local function json_ft()
    local group_id = vim.api.nvim_create_augroup('mikatpt_json_ft', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
        group = group_id,
        pattern = {
            'tsconfig.json',
            'package.json',
            'pyrightconfig.json',
            'jest.config.json',
            'babel.config.json',
            '*eslintrc.json',
            '*prettierrc.json',
        },
        callback = function()
            vim.bo.filetype = 'jsonc'
        end,
    })
end

local function commands()
    vim.api.nvim_create_user_command('Format', function()
        vim.lsp.buf.formatting_sync(nil, 1000)
    end, {})

    vim.api.nvim_create_user_command('W', function()
        vim.cmd('w')
    end, {})

    -- check highlight group for current item under cursor
    vim.api.nvim_create_user_command('SynID', function()
        vim.cmd('echo synIDattr(synID(line("."), col("."), 1), "name")')
    end, {})
end

auto_close_tree()
autokeybinds()
mouse_events()
update_keywords()
commands()
json_ft()
