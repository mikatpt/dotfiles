return function()
    local dap = require('dap')

    -- go install github.com/go-delve/delve/cmd/dlv@latest
    dap.adapters.delve = {
        type = 'server',
        port = '${port}',
        executable = {
            command = 'dlv',
            args = { 'dap', '-l', '127.0.0.1:${port}' },
        },
    }

    dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = { vim.loop.os_homedir() .. '/.debug/vscode-node-debug2/out/src/nodeDebug.js' },
    }

    dap.configurations.go = {
        {
            type = 'delve',
            name = 'Debug',
            request = 'launch',
            program = '${file}',
        },
        {
            type = 'delve',
            name = 'Debug test', -- configuration for debugging test files
            request = 'launch',
            mode = 'test',
            program = '${file}',
        },
        -- works with go.mod packages and sub packages
        {
            type = 'delve',
            name = 'Debug test (go.mod)',
            request = 'launch',
            mode = 'test',
            program = './${relativeFileDirname}',
        },
    }
    dap.configurations.javascript = {
        {
            name = 'Launch',
            type = 'node2',
            request = 'launch',
            program = '${file}',
            protocol = 'inspector',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            -- console = 'integratedTerminal',
            console = 'internalConsole',
        },
    }

    -- lldb adapter defined in lspconfig.rust-tools.lua
    dap.configurations.rust = {
        {
            name = 'launch',
            type = 'lldb',
            request = 'launch',
            program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
            terminal = 'console',
            sourceLanguages = { 'rust' },
            targetArchitecture = 'x86_64',
        },
    }
end
