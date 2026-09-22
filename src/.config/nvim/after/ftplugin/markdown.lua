require('quarto').activate()

local runner = require('quarto.runner')
local opts = { buffer = true, silent = true }
vim.keymap.set('n', '<leader>re', runner.run_cell, opts)
vim.keymap.set('n', '<leader>rr', runner.run_cell, opts)
vim.keymap.set('n', '<leader>ra', runner.run_above, opts)
vim.keymap.set('n', '<leader>rA', runner.run_all, opts)
vim.keymap.set('v', '<leader>rc', runner.run_range, opts)

vim.keymap.set('n', '<leader>ri',  '<CMD>MoltenInit<CR>', opts)
vim.keymap.set('n', '<leader>rl',  '<CMD>MoltenEvaluateLine<CR>', opts)
vim.keymap.set('n', '<leader>rd',  '<CMD>MoltenDelete<CR>', opts)
vim.keymap.set('n', '<leader>ros', ':noautocmd MoltenEnterOutput<CR>', { buffer = true, silent = false })
vim.keymap.set('n', '<leader>roh', '<CMD>MoltenHideOutput<CR>', opts)
