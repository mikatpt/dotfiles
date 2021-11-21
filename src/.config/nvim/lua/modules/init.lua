-- stylua: ignore start
local utils = require('core.utils')
utils.fn.setup_packer()

local packer = require('packer')
local c = require('modules.config')
local get_local = utils.fn.get_local_plugin

-- NOTE: opt is set true, so all plugins are lazy-loaded.
return packer.startup(function(use)
    use({ 'wbthomason/packer.nvim',               event = 'BufEnter',     commit = 'a5f8858'   })

    -- Colorscheme & Icons
    use({ 'kyazdani42/nvim-web-devicons',         module = 'nvim-web-devicons'                 })
    use({ 'onsails/lspkind-nvim',                 module = 'lspkind',     config = c.lspkind   })
    use({ 'rktjmp/lush.nvim',                     module = 'lush'                              })
    use({ get_local('mikatpt', 'lucid_nvim'),     module = 'lucid'                             })

    -- Core vim/neovim
    use({ 'tpope/vim-commentary',                 event = 'BufRead'                            })
    use({ 'machakann/vim-sandwich',               event = 'BufRead'                            })
    use({ 'vim-utils/vim-man',                    event = 'BufRead'                            })
    use({ 'mg979/vim-visual-multi',               event = 'BufRead'                            })
    use({ 'plasticboy/vim-markdown',              event = 'BufRead'                            })
    use({ 'mbbill/undotree',                      event = 'BufRead'                            })
    use({ 'nvim-lua/plenary.nvim',                event = 'BufEnter',     module = {'plenary'} })
    use({ 'nvim-lua/popup.nvim',                  module = 'popup'                             })
    use({ 'tpope/vim-fugitive',  requires = { 'tpope/vim-rhubarb' },      event = 'BufRead'    })

    -- Display
    use({ 'lewis6991/gitsigns.nvim',              after = 'plenary.nvim', config = c.gitsigns  })
    use({ 'famiu/feline.nvim',   tag = 'v0.3.3',  event = 'BufRead',      config = c.feline    })
    use({ 'folke/trouble.nvim',                   event = 'BufRead',      config = c.trouble   })
    use({ 'folke/todo-comments.nvim',             event = 'BufRead',      config = c.todo      })
    use({ 'lukas-reineke/indent-blankline.nvim',  event = 'BufRead' ,     config = c.blankline })
    use({ 'glepnir/dashboard-nvim',                                       config = c.dashboard,
        cmd = { 'Dashboard', 'DashboardNewFile', 'SessionLoad', 'SessionSave' },
    })

    -- Navigation
    use({ get_local('ThePrimeagen', 'harpoon'),       event = 'BufEnter'                       })
    use({ get_local('mikatpt', 'harpoon-finder'),     after = 'harpoon'                        })
    use({ 'kyazdani42/nvim-tree.lua',                 event = 'BufEnter', config = c.nvim_tree })
    use({ 'nvim-telescope/telescope.nvim',            cmd = 'Telescope',
        module = { 'telescope', 'telescope.builtin' },                    config = c.telescope,
        requires = {
            { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make',   event = 'BufEnter'  },
        },
    })

    -- Language Server Protocol
    use({ 'nvim-treesitter/nvim-treesitter',          event = 'BufRead' , config = c.treesitter,
        run = ':TSUpdate', requires = { 'nvim-treesitter/nvim-treesitter-refactor' }
    })
    use({ 'neovim/nvim-lspconfig',                    event = 'BufRead' , config = c.lsp,
        requires = {
            { 'folke/lua-dev.nvim',                   module = 'lua-dev'                      },
            { 'williamboman/nvim-lsp-installer',      module = 'nvim-lsp-installer'           },
            { 'tami5/lspsaga.nvim',                   module = 'lspsaga'                      },
            { 'ray-x/lsp_signature.nvim',             module = 'lsp_signature'                },
            { 'jose-elias-alvarez/nvim-lsp-ts-utils', module = 'nvim-lsp-ts-utils'            },
            { 'hrsh7th/cmp-nvim-lsp',                 module = 'cmp_nvim_lsp'                 },
        },
    })
    use({ 'Vimjas/vim-python-pep8-indent',   event = 'BufRead'                                 })
    use({ 'leafgarland/typescript-vim',      event = 'BufRead'                                 })
    use({ 'mfussenegger/nvim-dap',           after = 'nvim-lspconfig', config = c.dap          })
    use({ 'simrat39/rust-tools.nvim',        after = 'nvim-dap',       config = c.rust_tools   })

    -- Completion
    use({ 'hrsh7th/nvim-cmp',                event = 'InsertEnter',    config = c.cmp,
        requires = { 'hrsh7th/vim-vsnip', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-vsnip' },
    })
    use({ 'windwp/nvim-autopairs',           after = 'nvim-cmp',       config = c.autopairs    })

    packer.install()
    packer.compile()
end)
