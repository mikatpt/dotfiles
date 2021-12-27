local eslint = {
    lintCommand = 'eslint_d -f visualstudio --stdin --stdin-filename ${INPUT}',
    formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename ${INPUT}',
    lintIgnoreExitCode = true,
    lintStdin = true,
    formatStdin = true,
    lintFormats = { '%f(%l,%c): %tarning %m', '%f(%l,%c): %rror %m' },
}

local prettier = {
    formatCommand = [[$([ -n "$(command -v node_modules/.bin/prettier)" ] && echo "node_modules/.bin/prettier" || echo "prettier") --stdin-filepath ${INPUT} ${--config-precedence:"prefer-file"}]],
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

local stylua = {
    formatCommand = 'stylua -s -',
    formatStdin = true,
}

-- local rubocop = {
--     formatCommand = 'rubocop -f',
--     formatStdin = true,
-- }

return {
    lua = { stylua },
    javascript = { prettier, eslint },
    javascriptreact = { prettier, eslint },
    typescript = { prettier, eslint },
    typescriptreact = { prettier, eslint },
    go = { gofmt },
    rust = { rustfmt },
    -- ruby = { rubocop },
}
