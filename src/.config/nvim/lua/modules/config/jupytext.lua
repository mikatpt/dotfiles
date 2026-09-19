return function()
    -- markdown output (not quarto) avoids the noticeable open/save lag on .ipynb round-trips.
    require('jupytext').setup({
        style = 'markdown',
        output_extension = 'md',
        force_ft = 'markdown',
    })
end
