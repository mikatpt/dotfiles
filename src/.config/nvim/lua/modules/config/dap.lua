return function()
    local dap = require('dap')
    local utils = require('core.utils')

    dap.adapters.go = {
        type = 'executable',
        command = 'node',
        args = { utils.os.home .. '/.debug/vscode-go/dist/debugAdapter.js' },
    }

    dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = { utils.os.home .. '/.debug/vscode-node-debug2/out/src/nodeDebug.js' },
    }

    dap.configurations.go = {
        {
            type = 'go',
            name = 'Debug',
            request = 'launch',
            showLog = false,
            program = '${file}',
            -- program = '${fileDirname}',
            -- program = "${workspaceFolder}",
            dlvToolPath = vim.fn.exepath('dlv'), -- Adjust to where delve is installed
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
