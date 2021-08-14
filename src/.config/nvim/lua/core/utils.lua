local M = {}

function P(cmd)
    print(vim.inspect(cmd))
end

-- Os
M.os = {
    home = os.getenv('HOME'),
    data = vim.fn.stdpath('data'),
    cache = vim.fn.stdpath('cache'),
    config = vim.fn.stdpath('config'),
    name = vim.loop.os_uname().sysname,
    is_git_dir = os.execute(
        'git rev-parse --is-inside-work-tree >> /dev/null 2>&1'
    ),
}

return M
