-- Keep notebook fences visible so their code and boundaries remain editable.
vim.opt_local.conceallevel = 0
vim.opt_local.concealcursor = ''

require('quarto').activate()

local runner = require('quarto.runner')
local opts = { buffer = true, silent = true }
vim.keymap.set('n', '<leader>re', runner.run_cell, opts)
vim.keymap.set('n', '<leader>rr', runner.run_cell, opts)
vim.keymap.set('n', '<leader>ra', runner.run_above, opts)
vim.keymap.set('n', '<leader>rA', runner.run_all, opts)
vim.keymap.set('v', '<leader>rc', runner.run_range, opts)
