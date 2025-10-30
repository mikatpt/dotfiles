return function()
    local cmd_root = vim.fn.stdpath('data') .. '/mason/bin'
    local helpers = require('modules.lspconfig.helpers')

    local null_ls = require('null-ls')
    local h = require('null-ls.helpers')
    local gosimports_args = { '-formatonly' }
    if vim.loop.os_uname().sysname == 'Darwin' then
        table.insert(gosimports_args, '-local')
        table.insert(gosimports_args, 'github.cbhq.net/')
    end
    local gosimports = h.make_builtin({
        name = 'gosimports',
        meta = { url = 'https://github.com/rinchsan/gosimports', description = 'Formatter with smart import grouping' },
        method = null_ls.methods.FORMATTING,
        filetypes = { 'go' },
        generator_opts = {
            command = 'gosimports',
            args = gosimports_args,
            to_stdin = true,
        },
        factory = h.formatter_factory,
    })

    null_ls.setup({
        log_level = 'error',
        auto_start = true,
        root_dir = require('null-ls.utils').root_pattern('.git'),
        on_attach = helpers.on_attach,
        timeout_ms = 1000,
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
            gosimports,
            require('none-ls.formatting.rustfmt').with({
                extra_args = { '--edition=2021' },
            }),
            require('none-ls.formatting.autopep8').with({
                command = cmd_root .. '/autopep8',
            }),
        },
    })
end
