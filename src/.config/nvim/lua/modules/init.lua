require('modules.packerInit').setup()
local utils = require('core.utils')
local packer = require('packer')

-- Use for plugin contributions
local function get_local_plugin(author, plugin)
    local local_path = utils.os.home .. '/' .. plugin
    local remote_path = author .. '/' .. plugin
    return vim.fn.isdirectory(local_path) == 1 and local_path or remote_path
end

--[[ Template for adding a plugin
    use ({
         'plugin/name',
         config = require('modules.config.plugin_name'),
         event|cmd|module, -- ways to lazy load the plugin
         run = ':Command', -- any startup commands
         requires = {}
    })
--]]

-- NOTE: opt is set true, so all plugins are lazy-loaded.
-- Use modules|event|cmd|after options to load plugins
return packer.startup(function(use)
    -----[[-------------]]-----
    ---      ESSENTIALS     ---
    -----]]-------------[[-----

    use({ 'wbthomason/packer.nvim', event = 'VimEnter' })
    use({ 'nvim-lua/plenary.nvim', module = 'plenary', event = 'BufRead' })
    use({ 'nvim-lua/popup.nvim', module = 'popup', event = 'BufRead' })

    use({ 'tpope/vim-commentary', event = 'BufEnter' })
    use({ 'machakann/vim-sandwich', event = 'BufEnter' })
    use({ 'tpope/vim-fugitive', event = 'BufRead', requires = { 'tpope/vim-rhubarb' } })
    use({ 'mbbill/undotree', event = 'BufEnter' })
    use({ 'leafgarland/typescript-vim', event = 'BufRead' })
    use({ 'lukas-reineke/indent-blankline.nvim', event = 'BufRead', config = require('modules.config.blankline') })

    use({ 'vim-utils/vim-man', event = 'BufRead' })
    use({ 'plasticboy/vim-markdown', event = 'BufEnter' })

    -- funky compiler stuff on mac right now :(
    if utils.os.name ~= 'Darwin' then
        use({
            'nvim-neorg/neorg',
            config = require('modules.config.neorg'),
            after = 'nvim-treesitter',
        })
    end

    use({ 'rktjmp/lush.nvim', module = 'lush' })
    use({ get_local_plugin('mikatpt', 'lucid_nvim'), module = 'lucid' })

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
    use({ 'kyazdani42/nvim-web-devicons', event = 'VimEnter' })
    use({
        'kyazdani42/nvim-tree.lua',
        config = require('modules.config.nvim-tree'),
        after = 'nvim-web-devicons',
    })

    -- Quick navigation
    use({ get_local_plugin('ThePrimeagen', 'harpoon'), event = 'BufRead' })

    -- Pretty diagnostics
    use({
        'folke/trouble.nvim',
        config = require('modules.config.trouble'),
        event = 'BufRead',
    })
    use({ 'folke/todo-comments.nvim', event = 'BufRead', config = require('modules.config.todo') })

    -- Built-in lsp
    use({
        'neovim/nvim-lspconfig',
        config = require('modules.lspconfig'),
        event = 'BufEnter',
        requires = {
            { 'folke/lua-dev.nvim', module = 'lua-dev' },
            { 'kabouzeid/nvim-lspinstall', module = 'lspinstall' },
            { 'tami5/lspsaga.nvim', module = 'lspsaga' },
            { 'ray-x/lsp_signature.nvim', module = 'lsp_signature' },
            {
                'jose-elias-alvarez/nvim-lsp-ts-utils',
                module = 'nvim-lsp-ts-utils',
            },
            { 'hrsh7th/cmp-nvim-lsp', module = 'cmp_nvim_lsp' },
        },
    })

    use({
        'simrat39/rust-tools.nvim',
        config = require('modules.lspconfig.rust-tools'),
        after = 'nvim-dap',
    })

    -- Nice icons
    use({
        'onsails/lspkind-nvim',
        config = require('modules.config.lspkind'),
        event = 'VimEnter',
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
    use({ 'nvim-telescope/telescope-fzf-native.nvim', event = 'BufRead', run = 'make' })
    use({
        'nvim-telescope/telescope.nvim',
        config = require('modules.config.telescope'),
        cmd = 'Telescope',
        module = { 'telescope', 'telescope.builtin' },
        requires = { 'nvim-telescope/telescope-fzf-native.nvim' },
    })

    -- Debugging
    use({
        'mfussenegger/nvim-dap',
        config = require('modules.config.dap'),
        after = 'nvim-lspconfig',
    })

    -- Dashboard
    use({
        'glepnir/dashboard-nvim',
        cmd = {
            'Dashboard',
            'DashboardNewFile',
            'DashboardJumpMarks',
            'SessionLoad',
            'SessionSave',
        },
        config = require('modules.config.dashboard'),
    })

    -- Status line
    use({
        'famiu/feline.nvim',
        commit = 'fcbd00d',
        config = require('modules.config.feline'),
        event = 'BufRead',
    })

    -- Git status in gutter
    use({
        'lewis6991/gitsigns.nvim',
        config = require('modules.config.gitsigns'),
        after = 'plenary.nvim',
    })

    packer.install()
    packer.compile()
end)
