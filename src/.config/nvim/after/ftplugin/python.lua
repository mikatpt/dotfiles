-- Find the '# %%' cell containing the cursor, for jupytext-percent-style .py files.
local function percent_cell_range()
    local total = vim.fn.line('$')
    local cur = vim.fn.line('.')

    local first = 1
    for l = cur, 1, -1 do
        if vim.fn.getline(l):match('^#%s*%%%%') then
            first = l + 1
            break
        end
    end

    local last = total
    for l = cur + 1, total do
        if vim.fn.getline(l):match('^#%s*%%%%') then
            last = l - 1
            break
        end
    end

    return first, last
end

vim.keymap.set('n', '<leader>re', function()
    local first, last = percent_cell_range()
    vim.fn.MoltenEvaluateRange(first, last)
end, { buffer = true, silent = true, desc = 'molten: evaluate %% cell' })
