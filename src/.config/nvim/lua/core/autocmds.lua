-- use augroups to make this file idempotent!
local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd

local group_id = ag('mikatpt_autocmds', {})

local function auto_close_tree()
    -- We want this to only run once, so we don't use the global group id.
    local id = ag('mikatpt_AutoCloseNvimTree', {})

    local cb = function()
        local ft = vim.bo.filetype
        if _G.auto_close_called or ft == 'NvimTree' or ft == 'TelescopePrompt' or ft == '' then
            return
        end

        _G.auto_close_called = true
        vim.defer_fn(function()
            au('BufEnter', {
                command = "if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif",
                nested = true,
            })
        end, 1000)
        vim.api.nvim_del_augroup_by_id(id)
    end

    au('BufEnter', {
        group = id,
        callback = cb,
    })
end

local function autokeybinds()
    local opts = { silent = true, noremap = true }
    au('Filetype', {
        group = group_id,
        pattern = { 'fugitive' },
        callback = function()
            vim.api.nvim_buf_set_keymap(0, 'n', 'cc', ':Git commit --quiet<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', 'ca', ':Git commit --quiet --amend<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', 'ce', ':Git commit --quiet --amend --no-edit<CR>', opts)
        end,
    })
    au('Filetype', {
        group = group_id,
        pattern = { 'lspinfo' },
        callback = function()
            vim.api.nvim_buf_set_keymap(0, 'n', 'q', ':q<CR>', opts)
            vim.api.nvim_buf_set_keymap(0, 'n', '<ESC>', ':q<CR>', opts)
        end,
    })
end

local function mouse_events()
    au('FocusLost', { group = group_id, pattern = { '*' }, command = 'set mouse=' })
    au('FocusGained', {
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
    au('BufEnter', {
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
    au({ 'BufNewFile', 'BufRead' }, {
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

local function hl_yank()
    au('TextYankPost', {
        group = group_id,
        pattern = '*',
        callback = function()
            vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 150 })
        end,
    })
end

local function commands()
    vim.api.nvim_create_user_command('Format', function()
        vim.lsp.buf.formatting_sync(nil, 1000)
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
hl_yank()
commands()
json_ft()
