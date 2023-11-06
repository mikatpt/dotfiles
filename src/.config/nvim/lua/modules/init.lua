-- stylua: ignore start
local utils = require('core.utils')
utils.fn.setup_lazy()

local c = require('modules.config')
local treesitter = 'nvim-treesitter/nvim-treesitter'
local fzf_build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'

local plugins = {
    -- Colorscheme & Icons
    { 'kyazdani42/nvim-web-devicons',                                                      },
    { 'onsails/lspkind-nvim',                lazy = true,            config = c.lspkind    },
    { 'rktjmp/lush.nvim',                                                                  },
    { 'mikatpt/lucid_nvim',                  dev = true,             config = c.colo       },

    -- Core vim
    { 'numToStr/Comment.nvim',               event = 'BufRead',      config = c.comment    },
    { 'tpope/vim-sleuth',                                                                  },
    { 'machakann/vim-sandwich',                                                            },
    { 'mg979/vim-visual-multi',              event  = 'BufRead'                            },
    { 'plasticboy/vim-markdown',             event  = 'BufEnter'                           },
    { 'mbbill/undotree',                     event  = 'BufRead'                            },
    { 'nvim-lua/plenary.nvim',                                                             },
    { 'tpope/vim-rhubarb',                                                                 },
    { 'tpope/vim-fugitive',                                                                },

    -- Display
    { treesitter,   run = ':TSUpdate',       event = 'BufRead',      config = c.treesitter },
    { treesitter .. '-refactor',             event = 'BufRead'                             },
    { treesitter .. '-textobjects',          event = 'BufRead'                             },
    { 'JoosepAlviste/nvim-ts-context-commentstring',                 event = 'BufRead'     },
    { 'nvim-treesitter/playground',          event = 'BufRead'                             },
    { 'windwp/nvim-ts-autotag',              event = 'BufRead'                             },
    { 'lewis6991/gitsigns.nvim',                                     config = c.gitsigns   },
    { 'feline-nvim/feline.nvim',             tag   = 'v1.1.3',       config = c.feline     },
    { 'j-hui/fidget.nvim',                   tag   = 'legacy'                              },
    { 'folke/trouble.nvim',                  event = 'BufRead',      config = c.trouble    },
    { 'folke/todo-comments.nvim',            event = 'BufRead',      config = c.todo       },
    { 'folke/noice.nvim',  dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' },
                                                                     config = c.noice      },
    { 'lukas-reineke/indent-blankline.nvim', event = 'BufRead',      config = c.blankline  },
    { 'goolord/alpha-nvim',                                          config = c.dashboard  },

    -- Navigation
    { 'ThePrimeagen/harpoon',                dev = true,                                   },
    { 'mikatpt/harpoon-finder',              dev = true,                                   },
    { 'kyazdani42/nvim-tree.lua',            commit = '086bf31',     config = c.nvim_tree  },
    { 'nvim-telescope/telescope-fzf-native.nvim',                    build  = fzf_build    },
    { 'nvim-telescope/telescope.nvim',                               config = c.telescope  },
    { 'junegunn/fzf',                        build = './install --bin'                     },
    { 'ahmedkhalf/project.nvim',                                     config = c.project    },

    -- Language Server Protocol
    { 'neovim/nvim-lspconfig',                                       config = c.lsp        },
    { 'williamboman/mason.nvim',                                                           },
    { 'williamboman/mason-lspconfig.nvim'                                                  },
    { 'jose-elias-alvarez/null-ls.nvim',                             config = c.null_ls    },
    { 'glepnir/lspsaga.nvim',                   lazy = true,         commit = '41c8fcf'    },
    { 'ray-x/lsp_signature.nvim',               lazy = true,                               },
    { 'mfussenegger/nvim-dap',                                       config = c.dap        },
    { 'rcarriga/nvim-dap-ui',                                        config = c.dapui      },
    { 'mikatpt/roadrunner',                     dev = true,          config = c.roadrunner },
    { 'github/copilot.vim',                                          config = c.copilot    },

    -- Languages
    { 'simrat39/rust-tools.nvim',               ft     = 'rust',     config = c.rust_tools },
    { 'folke/neodev.nvim',                      event  = 'BufRead',  lazy = true,          },
    { 'jose-elias-alvarez/nvim-lsp-ts-utils',   lazy   = true,                             },
    { 'MaxMEllon/vim-jsx-pretty',               event  = 'BufRead'                         },
    { 'leafgarland/typescript-vim',             event  = 'BufRead'                         },
    { 'Vimjas/vim-python-pep8-indent',          event  = 'BufRead'                         },
    { 'b0o/schemastore.nvim',                                                              },

    -- Databases
    { 'tpope/vim-dadbod'                                                                   },
    { 'kristijanhusak/vim-dadbod-ui',           config = c.dadbod                          },
    { 'kristijanhusak/vim-dadbod-completion',   event  = 'BufRead'                         },

    -- Completion
    { 'hrsh7th/nvim-cmp',    lazy = true,   event  = 'InsertEnter',  config = c.cmp        },
    { 'windwp/nvim-autopairs',              event  = 'InsertEnter',  config = c.autopairs  },
    { 'hrsh7th/cmp-nvim-lsp',               module = 'cmp_nvim_lsp', event  = 'BufRead'    },
    { 'hrsh7th/cmp-buffer',                 event  = 'BufRead'                             },
    { 'saadparwaiz1/cmp_luasnip',           event  = 'BufRead'                             },
    { 'L3MON4D3/LuaSnip',   tag = 'v1.1.0', event  = 'BufRead'                             },
}

local opts = {
    dev = {
        path = "~/foss",
        fallback = true,
    }
}

require("lazy").setup(plugins, opts)
