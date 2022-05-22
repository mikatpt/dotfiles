local prettier = {
    formatCommand = [[$([ -n "$(command -v node_modules/.bin/prettier)" ] && echo "node_modules/.bin/prettier" || echo "prettier") --stdin-filepath ${INPUT} ${--config-precedence:configPrecedence}]],
    formatStdin = true,
}

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
    javascript = { prettier },
    javascriptreact = { prettier },
    typescript = { prettier },
    typescriptreact = { prettier },
    go = { gofmt },
    rust = { rustfmt },
    -- ruby = { rubocop },
}
