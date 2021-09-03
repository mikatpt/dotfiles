local utils = require('core.utils')
local packer_url = 'https://github.com/wbthomason/packer.nvim'
local packer_path = utils.os.data .. '/site/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
    print('Downloading plugin manager...')
    vim.cmd('silent! !git clone ' .. packer_url .. ' ' .. packer_path)
end

vim.cmd('packadd packer.nvim')

local packer = require('packer')

return packer.startup(function(use)
    packer.init({
        compile_path = utils.os.data .. '/site/lua/packer_compiled.lua',
        opt_default = true,
        profile = { enable = true },
    })

    -----[[-------------]]-----
    ---      ESSENTIALS     ---
    -----]]-------------[[-----
    use({ 'wbthomason/packer.nvim', event = 'VimEnter' })
    use({ 'nvim-lua/plenary.nvim', module = 'plenary', event = 'BufRead'  })
    use({ 'nvim-lua/popup.nvim', module = 'popup', event = 'BufRead' })

    use({ 'tpope/vim-commentary', event = 'BufRead' })
    use({ 'machakann/vim-sandwich', event = 'BufRead' })
    use({ 'tpope/vim-fugitive', event = 'BufRead', requires = { 'tpope/vim-rhubarb'} })
    use({ 'mbbill/undotree', event = 'BufRead' })
    use({ 'leafgarland/typescript-vim', event = 'BufRead' })

    use({ 'vim-utils/vim-man', event = 'BufRead' })
    use({ 'godlygeek/tabular', event = 'BufEnter' })
    use({ 'plasticboy/vim-markdown', event = 'BufEnter' })
    use({ 'rktjmp/lush.nvim', event = 'BufRead' })

    --[[ Template for adding a plugin
        use ({
             'plugin/name'
             config = require('modules.config.plugin_name')
             event|cmd|module --> way to lazy load the plugin
             run = 'If it needs to run a command'
             requires = {}
        })
    --]]

    -- Treesitter
    use({
        'nvim-treesitter/nvim-treesitter',
        config = require('modules.treesitter'),
        event = 'BufRead',
        run = ':TSUpdate',
        requires = { 'nvim-treesitter/nvim-treesitter-refactor' },
    })

    -- File tree
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        event = 'BufRead'
    }

    -- Quick navigation
    use({
        'ThePrimeagen/harpoon',
        event = 'BufRead',
    })

    -- Pretty diagnostics
    use({
        'folke/trouble.nvim',
        config = require('modules.trouble'),
        event = 'BufRead'
    })

    -- Built-in lsp
    use({
        'neovim/nvim-lspconfig',
        config = require('modules.lspconfig'),
        event = 'BufEnter',
        requires = {
            { 'kabouzeid/nvim-lspinstall', module = 'lspinstall' },
            { 'glepnir/lspsaga.nvim', module = 'lspsaga' },
            { 'ray-x/lsp_signature.nvim', module = 'lsp_signature' },
            {
                'jose-elias-alvarez/nvim-lsp-ts-utils',
                module = 'nvim-lsp-ts-utils',
            },
            { 'hrsh7th/cmp-nvim-lsp', module = 'cmp_nvim_lsp' }
        },
    })

    use({
        'onsails/lspkind-nvim',
        config = require('modules.lspkind'),
        event = 'BufRead',
    })

    -- Text completion
    use({
        'hrsh7th/nvim-cmp',
        config = require('modules.cmp'),
        event = 'InsertEnter',
        requires = { 'hrsh7th/vim-vsnip', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-vsnip' },
    })

    -- Autopairs
    use({
        'windwp/nvim-autopairs',
        config = require('modules.autopairs'),
        after = 'nvim-cmp',
    })

    -- Fuzzy finding / Ctrl + p
    use({
        'nvim-telescope/telescope.nvim',
        config = require('modules.telescope'),
        cmd = "Telescope",
        module = 'telescope',
        requires = { 'nvim-telescope/telescope-fzy-native.nvim' },
    })

    -- Debugging
    use({
        'mfussenegger/nvim-dap',
        config = require('modules.dap'),
        event = 'BufEnter',
    })

    -- Dashboard
    use({
        'glepnir/dashboard-nvim',
        cmd = {
            "Dashboard",
            "DashboardNewFile",
            "DashboardJumpMarks",
            "SessionLoad",
            "SessionSave"
        },
        config = require('modules.dashboard'),
    })

    -- Status line
    use({
        'famiu/feline.nvim',
        config = require('modules.feline'),
        event = 'BufRead'
    })

    -- Git status in gutter
    use({
        'lewis6991/gitsigns.nvim',
        config = require('modules.gitsigns'),
        after = 'plenary.nvim'
    })

    packer.install()
    packer.compile()
end)
