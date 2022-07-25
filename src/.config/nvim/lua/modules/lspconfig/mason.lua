return function()
    local mason = require('mason')
    mason.setup({
        ui = {
            -- Accepts same border values as |nvim_open_win()|.
            border = 'none',
            icons = {
                package_installed = ' ',
                package_pending = ' ',
                package_uninstalled = ' ',
            },
            keymaps = {
                toggle_package_expand = '<CR>',
                install_package = 'i',
                update_package = 'u',
                check_package_version = 'c',
                update_all_packages = 'U',
                check_outdated_packages = 'C',
                uninstall_package = 'X',
                cancel_installation = '<C-c>',
                apply_language_filter = '<C-f>',
            },
        },
        install_root_dir = vim.fn.stdpath('data') .. '/mason',
        pip = { install_args = {} },
        log_level = vim.log.levels.WARN,
        max_concurrent_installers = 4,
        github = {
            -- The placeholders are the following (in order):
            -- 1. The repository (e.g. "rust-lang/rust-analyzer")
            -- 2. The release version (e.g. "v0.3.0")
            -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
            download_url_template = 'https://github.com/%s/releases/download/%s/%s',
        },
    })
end
