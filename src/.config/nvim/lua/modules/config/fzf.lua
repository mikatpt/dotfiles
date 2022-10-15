return function()
    require('fzf-lua').setup({
        fzf_opts = {
            ['--layout'] = 'default',
            ['--info'] = 'default',
        },
        fzf_colors = {
            ['hl'] = { 'fg', 'Special' },
            ['hl+'] = { 'fg', 'Special' },
            ['fg+'] = { 'fg', 'Tabline' },
            ['bg+'] = { 'bg', 'Visual' },
            ['prompt'] = { 'fg', 'Special' },
            ['gutter'] = { 'bg', 'VertSplit' },
            ['pointer'] = { 'fg', 'VertSplit' },
            ['marker'] = { 'fg', 'Normal' },
        },
    })
end
