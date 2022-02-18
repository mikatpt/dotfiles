-- stylua: ignore start
local utils = require('core.utils')
utils.fn.setup_packer()

local packer = require('packer')
local c = require('modules.config')
local get_local = utils.fn.get_local_plugin
local treesitter = 'nvim-treesitter/nvim-treesitter'

return packer.startup(function(use)
    use({ 'wbthomason/packer.nvim',              event = 'BufEnter'                            })

    -- Colorscheme & Icons
    use({ 'kyazdani42/nvim-web-devicons',                                                      })
    use({ 'onsails/lspkind-nvim',                module = 'lspkind',     config = c.lspkind    })
    use({ 'rktjmp/lush.nvim',                                                                  })
    use({ get_local('mikatpt', 'lucid_nvim'),                                                  })

    -- Core vim
    use({ 'tpope/vim-commentary',                event  = 'BufRead'                            })
    use({ 'machakann/vim-sandwich',              event  = 'BufRead'                            })
    use({ 'vim-utils/vim-man',                   event  = 'BufRead'                            })
    use({ 'mg979/vim-visual-multi',              event  = 'BufRead'                            })
    use({ 'plasticboy/vim-markdown',             event  = 'BufRead'                            })
    use({ 'mbbill/undotree',                     event  = 'BufRead'                            })
    use({ 'nvim-lua/plenary.nvim',                                                             })
    use({ 'nvim-lua/popup.nvim',                                                               })
    use({ 'tpope/vim-fugitive',                  requires = { 'tpope/vim-rhubarb' }            })

    -- Display
    use({ treesitter,                            run = ':TSUpdate',      config = c.treesitter })
    use({ treesitter .. '-refactor',                                                           })
    use({ 'lewis6991/gitsigns.nvim',             after = 'plenary.nvim', config = c.gitsigns   })
    use({ 'famiu/feline.nvim',                   tag   = 'v1.0.0',       config = c.feline     })
    use({ 'folke/trouble.nvim',                  event = 'BufRead',      config = c.trouble    })
    use({ 'folke/todo-comments.nvim',            event = 'BufRead',      config = c.todo       })
    use({ 'lukas-reineke/indent-blankline.nvim', event = 'BufRead',      config = c.blankline  })
    use({ 'glepnir/dashboard-nvim'                                                             })

    -- Navigation
    use({ get_local('ThePrimeagen', 'harpoon'),                                                })
    use({ get_local('mikatpt', 'harpoon-finder'),                                              })
    use({ 'kyazdani42/nvim-tree.lua',                                    config = c.nvim_tree  })
    use({ 'nvim-telescope/telescope-fzf-native.nvim',                    run    = 'make'       })
    use({ 'nvim-telescope/telescope.nvim',                               config = c.telescope  })

    -- Language Server Protocol
    use({ get_local('neovim', 'nvim-lspconfig'),                         config = c.lsp        })
    use({ 'williamboman/nvim-lsp-installer',        module = 'nvim-lsp-installer'              })
    use({ 'tami5/lspsaga.nvim',                     module = 'lspsaga'                         })
    use({ 'ray-x/lsp_signature.nvim',               module = 'lsp_signature'                   })
    use({ 'mfussenegger/nvim-dap',                                       config = c.dap        })
    use({ 'rcarriga/nvim-dap-ui',                   after  = 'nvim-dap', config = c.dapui      })

    -- Languages
    use({ 'simrat39/rust-tools.nvim',                                    config = c.rust_tools })
    use({ 'folke/lua-dev.nvim',                     event = 'BufRead',   module = 'lua-dev'    })
    use({ 'jose-elias-alvarez/nvim-lsp-ts-utils',   module = 'nvim-lsp-ts-utils'               })
    use({ 'leafgarland/typescript-vim',             event  = 'BufRead'                         })
    use({ 'Vimjas/vim-python-pep8-indent',          event  = 'BufRead'                         })

    -- Completion
    use({ 'hrsh7th/nvim-cmp',   module = 'cmp', event  = 'BufRead',      config = c.cmp        })
    use({ 'windwp/nvim-autopairs',              after  = 'nvim-cmp',     config = c.autopairs  })
    use({ 'hrsh7th/cmp-nvim-lsp',               module = 'cmp_nvim_lsp', event = 'BufRead'     })
    use({ 'hrsh7th/vim-vsnip',                  event  = 'BufRead'                             })
    use({ 'hrsh7th/cmp-buffer',                 event  = 'BufRead'                             })
    use({ 'hrsh7th/cmp-vsnip',                  event  = 'BufRead'                             })

    packer.install()
    packer.compile()
end)
