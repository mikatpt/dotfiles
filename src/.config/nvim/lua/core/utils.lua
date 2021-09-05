local M = {}

function P(cmd)
    print(vim.inspect(cmd))
end

local function is_git_dir()
    if os.execute('git rev-parse --is-inside-work-tree >> /dev/null 2>&1') == 0 then
        return 1
    else
        return 0
    end
end

local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

-- copied from tjdevries
local function get_lua_runtime()
    local result = {};
    for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
        local lua_path = path .. "/lua/";
        if vim.fn.isdirectory(lua_path) then
            result[lua_path] = true
        end
    end

    -- This loads the `lua` files from nvim into the runtime.
    result[vim.fn.expand("$VIMRUNTIME/lua")] = true

    return result;
end

-- Os
M.os = {
    home = os.getenv('HOME'),
    data = vim.fn.stdpath('data'),
    cache = vim.fn.stdpath('cache'),
    config = vim.fn.stdpath('config'),
    name = vim.loop.os_uname().sysname,
}

-- Misc functions
M.fn = {
    is_git_dir = is_git_dir,
    cmp_select_next = function(fallback)
        if vim.fn.pumvisible() == 1 then
            vim.fn.feedkeys(t('<C-N>'), 'n')
        elseif vim.fn['vsnip#available']() == 1 then
            vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
        else
            fallback()
        end
    end,
    cmp_select_prev = function(_, fallback)
        if vim.fn.pumvisible() == 1 then
            vim.fn.feedkeys(t('<C-P>'), 'n')
        elseif vim.fn['vsnip#available']() == 1 then
            vim.fn.feedkeys(t('<Plug>(vsnip-jump-prev)'), '')
        else
            fallback()
        end
    end,
    get_lua_runtime = get_lua_runtime,
}

return M
