lua << EOF
-- Language Servers
-- npm i -g typescript typescript-language-server pyright graphql-language-service-cli
-- :TSInstall go python javascript graphql typescript rust bash

-- lsp configs.
require'lspconfig'.pyright.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.tsserver.setup{}
require'lspconfig'.graphql.setup{}
require'lspconfig'.gopls.setup{}

-- Autopairs
require('nvim-autopairs').setup{}
require('nvim-autopairs').setup({
  disable_filetype = { "TelescopePrompt" , "vim" },
})
require("nvim-autopairs.completion.compe").setup({
  map_cr = true, --  map <CR> on insert mode
  map_complete = true, -- it will auto insert `(` after select function or method item
  auto_select = false,  -- auto select first item
})

-- treesitter configs
require'nvim-treesitter.configs'.setup{
  ensure_installed = "maintained",
  ignore_install = { "javascript" },
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { "c", },  -- list of language that will be disabled
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  refactor = {
      highlight_definitions = { enable = true},
      smart_rename = {
          enable = true,
          keymaps = {
              smart_rename = "<leader>rn",
          },
      },
  },
}



-- compe config
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}
EOF

