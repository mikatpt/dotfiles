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

-- Os
M.os = {
    home = os.getenv('HOME'),
    data = vim.fn.stdpath('data'),
    cache = vim.fn.stdpath('cache'),
    config = vim.fn.stdpath('config'),
    name = vim.loop.os_uname().sysname,
    is_git_dir = is_git_dir,
}

return M
