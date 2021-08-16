-- Format servers
local gofmt = {
    { formatCommand = 'gofmt', formatStdin = true },
}

return {
    go = { gofmt },
}
