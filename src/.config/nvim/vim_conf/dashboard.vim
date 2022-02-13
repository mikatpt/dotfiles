lua packer_plugins = packer_plugins or {}
let g:dashboard_footer_icon = '🐬 '
let g:dashboard_disable_at_vimenter = 1
let g:dashboard_preview_file_height = 12
let g:dashboard_preview_file_width = 80
let g:dashboard_disable_statusline = 1
let g:dashboard_default_executive = 'telescope'
let g:dashboard_custom_section = { 
    \ 'a': {
    \     'description': [ '" Open Tree                            CTL n' ],
    \     'command': ':NvimTreeToggle',
    \ },
    \ 'b': {
    \     'description': [ '  Recently opened                      SPC o' ],
    \     'command': 'lua require"telescope.builtin".oldfiles()',
    \ },
    \ 'c': {
    \     'description': [ '  Git files                            CTL p' ],
    \     'command': 'silent! lua require"telescope.builtin".git_files()',
    \ },
    \ 'd': {
    \     'description': [ '  Find word                            SPC r' ],
    \     'command': 'lua require"telescope.builtin".grep_string({ search : vim.fn.input("Grep For > ")})',
    \ },
    \ 'e': {
    \     'description': [ '  Config files                         SPC z' ],
    \     'command': 'lua require"telescope.builtin".git_files({cwd : "$HOME/.config/nvim" })',
    \ },
\ }

let g:dashboard_custom_header = [
    \ '',
    \ '',
    \ '',
    \ ' ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗',
    \ ' ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║',
    \ ' ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║',
    \ ' ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║',
    \ ' ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║',
    \ ' ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝',
    \ '',
    \ ]
