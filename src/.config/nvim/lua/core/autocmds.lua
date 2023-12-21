-- use augroups to make this file idempotent!
local ag = vim.api.nvim_create_augroup
local au = vim.api.nvim_create_autocmd
local cmd = vim.api.nvim_create_user_command

local group_id = ag('mikatpt_autocmds', {})

local function auto_close_tree()
    local function close_tree(winnr)
        local info = vim.fn.getbufinfo({ buf = vim.api.nvim_win_get_buf(winnr) })[1]
        local windows = vim.tbl_filter(function(w)
            return w ~= winnr
        end, vim.api.nvim_tabpage_list_wins(vim.api.nvim_win_get_tabpage(winnr)))
        local buffers = vim.tbl_map(vim.api.nvim_win_get_buf, windows)

        if info.name:match('.*NvimTree_%d*$') then
            if not vim.tbl_isempty(buffers) then
                pcall(require('nvim-tree.api').tree.close)
            end
        else
            if #buffers == 1 then
                local last_buffer = vim.fn.getbufinfo(buffers[1])[1]
                if last_buffer.name:match('.*NvimTree_%d*$') then
                    vim.schedule(function()
                        if #vim.api.nvim_list_wins() == 1 then
                            vim.cmd('quit')
                        else
                            vim.api.nvim_win_close(windows[1], true)
                        end
                    end)
                end
            end
        end
    end

    au('WinClosed', {
        group = group_id,
        callback = function()
            local winnr = tonumber(vim.fn.expand('<amatch>'))
            vim.schedule_wrap(close_tree(winnr)) ---@diagnostic disable-line
        end,
        nested = true,
    })
end

local function open_tree()
    -- VimEnter callback is passed { buf, file, event }
    local function _open_tree(data)
        local is_dir = vim.fn.isdirectory(data.file) == 1
        if not is_dir then
            return
        end
        require('nvim-tree.api').tree.open()
    end

    au('VimEnter', { callback = _open_tree, group = group_id })
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

    local syntax_list = vim.split(vim.fn.execute('syntax list'), '\n') ---@diagnostic disable-line
    local todo_lines = vim.tbl_filter(function(line)
        return string.find(line, '^%a*Todo') ~= nil
    end, syntax_list)

    local todo_groups = vim.tbl_map(function(line)
        return string.gsub(line, ' .*$', '') ---@diagnostic disable-line
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
    cmd('UpdateToDo', function()
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

local function hls()
    au('CmdlineEnter', {
        group = group_id,
        pattern = '/,\\?',
        callback = function()
            vim.o.hlsearch = true
        end,
    })
    au('CmdlineLeave', {
        group = group_id,
        pattern = '/,\\?',
        callback = function()
            vim.o.hlsearch = false
        end,
    })
end

local function copilot_disable()
    au('BufRead', {
        group = group_id,
        pattern = { '**/coding/advent/**' },
        callback = function()
            vim.b.copilot_enabled = false
        end,
    })
end

local function commands()
    cmd('Format', function()
        vim.lsp.buf.formatting_sync(nil, 1000)
    end, {})

    -- check highlight group for current item under cursor
    cmd('SynID', function()
        vim.cmd('echo synIDattr(synID(line("."), col("."), 1), "name")')
    end, {})

    -- Clears Noice message history
    cmd('Clear', function()
        local Manager = require('noice.message.manager')
        local messages = Manager.get({ has = true }, { history = true })
        for _, msg in ipairs(messages) do
            Manager.remove(msg)
        end
    end, {})
end

function P(...)
    local msgs = ''
    for _, v in ipairs({ ... }) do
        msgs = msgs .. vim.inspect(v) .. '\n'
    end
    -- remove last newline
    msgs = msgs:sub(1, -2)
    vim.notify(msgs, vim.log.levels.INFO, {
        title = 'Debug',
        on_open = function(win)
            vim.wo[win].conceallevel = 3
            vim.wo[win].concealcursor = ''
            vim.treesitter.start(vim.api.nvim_win_get_buf(win), 'lua')
        end,
    })
end

auto_close_tree()
hls()
open_tree()
autokeybinds()
mouse_events()
update_keywords()
hl_yank()
commands()
copilot_disable()
json_ft()
