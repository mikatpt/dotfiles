local eslint = {
    lintCommand = 'eslint_d -f visualstudio --stdin --stdin-filename=${INPUT}',
    formatCommand = 'eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}',
    lintIgnoreExitCode = true,
    lintStdin = true,
    formatStdin = true,
    lintFormats = { '%f(%l,%c): %tarning %m', '%f(%l,%c): %rror %m' },
}

-- This doesn't work on windows right now :(
-- Use eslint to call prettier for now.
-- local prettier = {
--     formatCommand = ([[
--     $([ -n "$(command -v node_modules/.bin/prettier)" ] && echo "node_modules/.bin/prettier" || echo "prettier")
--     ${--config-precedence:"prefer-file"}
--     ]]):gsub("\n", ""),
--     formatStdin = true,
-- }

local gofmt = {
    formatCommand = 'gofmt',
    formatStdin = true,
}

local rustfmt = {
    formatCommand = 'rustfmt --edition 2021',
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
    javascript = { eslint },
    javascriptreact = { eslint },
    typescript = { eslint },
    typescriptreact = { eslint },
    go = { gofmt },
    rust = { rustfmt },
    -- ruby = { rubocop },
}
