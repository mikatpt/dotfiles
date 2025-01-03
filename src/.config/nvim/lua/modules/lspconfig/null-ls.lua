return function()
    local cmd_root = vim.fn.stdpath('data') .. '/mason/bin'
    local helpers = require('modules.lspconfig.helpers')
    local null_ls = require('null-ls')

    null_ls.setup({
        log_level = 'error',
        auto_start = true,
        root_dir = require('null-ls.utils').root_pattern('.git'),
        on_attach = helpers.on_attach,
        sources = {
            require('none-ls.diagnostics.eslint_d').with({
                condition = function(utils)
                    return utils.root_has_file({ '.eslintrc.js', '.eslintrc', '.eslintrc.json' })
                end,
                diagnostic_config = { virtual_text = false },
            }),
            null_ls.builtins.formatting.stylua.with({
                command = cmd_root .. '/stylua',
                args = { '-s', '-' },
            }),
            null_ls.builtins.formatting.prettier.with({
                filetypes = {
                    'css',
                    'handlebars',
                    'html',
                    'javascript',
                    'javascriptreact',
                    'json',
                    'jsonc',
                    'less',
                    'scss',
                    'typescript',
                    'typescriptreact',
                    'vue',
                },
            }),
            null_ls.builtins.formatting.gofmt,
            require('none-ls.formatting.rustfmt').with({
                extra_args = { '--edition=2021' },
            }),
            require('none-ls.formatting.autopep8').with({
                command = cmd_root .. '/autopep8',
            }),
        },
    })
end
