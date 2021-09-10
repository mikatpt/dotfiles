require'modules.packerInit'.setup()
local utils = require('core.utils')
local packer = require('packer')

--[[ Template for adding a plugin
    use ({
         'plugin/name',
         config = require('modules.config.plugin_name'),
         event|cmd|module, -- ways to lazy load the plugin
         run = ':Command', -- any startup commands
         requires = {}
    })
--]]

-- NOTE: opt is set true, so all plugins are lazy-loaded. Here are your options:
-- Use modules|event|cmd|after options to load plugins
return packer.startup(function(use)

    -----[[-------------]]-----
    ---      ESSENTIALS     ---
    -----]]-------------[[-----

    use({ 'wbthomason/packer.nvim', event = 'VimEnter' })
    use({ 'nvim-lua/plenary.nvim', module = 'plenary', event = 'BufRead'  })
    use({ 'nvim-lua/popup.nvim', module = 'popup', event = 'BufRead' })

    use({ 'tpope/vim-commentary', event = 'BufEnter' })
    use({ 'machakann/vim-sandwich', event = 'BufEnter' })
    use({ 'tpope/vim-fugitive', event = 'BufRead', requires = { 'tpope/vim-rhubarb'} })
    use({ 'mbbill/undotree', event = 'BufEnter' })
    use({ 'leafgarland/typescript-vim', event = 'BufRead' })

    use({ 'vim-utils/vim-man', event = 'BufRead' })
    use({ 'plasticboy/vim-markdown', event = 'BufEnter' })
    use({
        'nvim-neorg/neorg',
        config = require('modules.config.neorg'),
        after = 'nvim-treesitter'
    })

    local lucid = '~/lucid_nvim'
    if vim.fn.isdirectory(utils.os.home .. '/lucid_nvim') ~= 1 then
        lucid = 'mikatpt/lucid_nvim'
    end
    use({ 'rktjmp/lush.nvim', module = 'lush' })
    use({ lucid, module = 'lucid' })

    -- TODO: Plugins to explore.
    --
    -- Dots for spaces:
    -- use({ 'lukas-reineke/indent-blankline.nvim', event = 'BufRead' })
    --
    -- Fancier TODO - currently we have TODO, FIXME, XXX natively with LSP. This allows searching them.
    -- See how well this integrates with trouble.nvim
    -- use({ 'folke/todo-comments.nvim', event = 'BufRead' })
    --
    -- I really want to like these two. It'll take a LOT of configuring, I think...
    -- use({ 'msjpq/chadtree', event = 'VimEnter' })
    -- use({ 'msjpq/coq_nvim', branch = 'coq' })

    -----[[--------------]]-----
    ---     IDE Features     ---
    -----[[--------------]]-----

    -- Treesitter
    use({
        'nvim-treesitter/nvim-treesitter',
        config = require('modules.config.treesitter'),
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
        config = require('modules.config.trouble'),
        event = 'BufRead'
    })

    -- Built-in lsp
    use({
        'neovim/nvim-lspconfig',
        config = require('modules.lspconfig'),
        event = 'BufEnter',
        requires = {
            { 'folke/lua-dev.nvim', module = 'lua-dev' },
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

    -- Nice icons
    use({
        'onsails/lspkind-nvim',
        config = require('modules.config.lspkind'),
        event = 'BufRead',
    })

    -- Text completion
    use({
        'hrsh7th/nvim-cmp',
        config = require('modules.config.cmp'),
        event = 'InsertEnter',
        requires = { 'hrsh7th/vim-vsnip', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-vsnip' },
    })

    -- Autopairs
    use({
        'windwp/nvim-autopairs',
        config = require('modules.config.autopairs'),
        after = 'nvim-cmp',
    })

    -- Fuzzy finding / Ctrl + p
    use({
        'nvim-telescope/telescope.nvim',
        config = require('modules.config.telescope'),
        cmd = "Telescope",
        module = { 'telescope', 'telescope.builtin' },
        requires = { 'nvim-telescope/telescope-fzy-native.nvim' },
    })

    -- Debugging
    use({
        'mfussenegger/nvim-dap',
        config = require('modules.config.dap'),
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
        config = require('modules.config.dashboard'),
    })

    -- Status line
    use({
        'famiu/feline.nvim',
        config = require('modules.config.feline'),
        event = 'BufRead'
    })

    -- Git status in gutter
    use({
        'lewis6991/gitsigns.nvim',
        config = require('modules.config.gitsigns'),
        after = 'plenary.nvim'
    })

    packer.install()
    packer.compile()
end)
