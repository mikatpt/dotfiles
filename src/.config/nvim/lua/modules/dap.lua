return function ()
    local dap = require('dap')
    local utils = require('core.utils')

    dap.adapters.go = {
        type = 'executable';
        command = 'node';
        args = {utils.os.home .. '/.debug/vscode-go/dist/debugAdapter.js'};
    }
    dap.configurations.go = {
        {
            type = 'go';
            name = 'Debug';
            request = 'launch';
            showLog = false;
            program = "${file}";
            -- program = "${workspaceFolder}";
            dlvToolPath = vim.fn.exepath('dlv')  -- Adjust to where delve is installed
        },
    }

    dap.adapters.node2 = {
        type = 'executable',
        command = 'node',
        args = {utils.os.home .. '/.debug/vscode-node-debug2/out/src/nodeDebug.js'},
    }
    dap.configurations.javascript = {
        {
            type = 'node2',
            request = 'launch',
            program = '${workspaceFolder}/${file}',
            protocol = 'inspector',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            console = 'integratedTerminal',
        },
    }
end


