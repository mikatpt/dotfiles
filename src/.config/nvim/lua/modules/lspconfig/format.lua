-- linting runs automatically, and formatting runs either on save or using <leader>s
-- in general, the lintStdin/formatStdin options are required
-- nothing to install from nvim directly - install each linter yourself.

local eslint = {
    lintCommand = 'eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}',
    formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename ${INPUT}',
    lintIgnoreExitCode = true,
    lintStdin = true,
    formatStdin = true,
    lintFormats = { '%f(%l,%c): %tarning %m', '%f(%l,%c): %rror %m'},
}

local prettier = {
    formatCommand = 'prettier --stdin-filepath ${INPUT}',
    formatStdin = true,
}

local gofmt = {
    formatCommand = 'gofmt',
    formatStdin = true,
}

local rustfmt = {
    formatCommand = 'rustfmt',
    formatStdin = true,
}

-- local rubocop = {
--     formatCommand = 'rubocop -f',
--     formatStdin = true,
-- }

return {
    javascript = { prettier, eslint },
    javascriptreact = { prettier, eslint },
    typescript = { prettier, eslint },
    typescriptreact = { prettier, eslint },
    go = { gofmt },
    rust = { rustfmt },
    -- ruby = { rubocop },
}

