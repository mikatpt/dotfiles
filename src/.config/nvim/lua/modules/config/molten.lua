return function()
    vim.g.molten_auto_open_output = false
    vim.g.molten_enter_output_behavior = 'open_and_enter'
    vim.g.molten_image_provider = 'image.nvim'
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
    vim.g.molten_virt_lines_off_by_1 = true

    local fallback_kernel = 'mikatpt'
    local group = vim.api.nvim_create_augroup('mikatpt_molten_ipynb', { clear = true })

    -- On open: pick a kernel matching the notebook's kernelspec (or the active venv) and
    -- pull in any outputs already saved in the .ipynb, so we don't lose them on re-export.
    local import_output = function(e)
        vim.schedule(function()
            local kernels = vim.fn.MoltenAvailableKernels()
            local ok, kernel_name = pcall(function()
                local metadata = vim.json.decode(io.open(e.file, 'r'):read('a'))['metadata']
                return metadata.kernelspec.name
            end)
            if not ok or not vim.tbl_contains(kernels, kernel_name) then
                kernel_name = nil
                local venv = os.getenv('VIRTUAL_ENV') or os.getenv('CONDA_PREFIX')
                if venv ~= nil then
                    kernel_name = string.match(venv, '/.+/(.+)')
                end
            end
            if kernel_name == nil and vim.tbl_contains(kernels, fallback_kernel) then
                kernel_name = fallback_kernel
            end
            if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
                vim.cmd(('MoltenInit %s'):format(kernel_name))
            end
            vim.cmd('MoltenImportOutput')
        end)
    end

    vim.api.nvim_create_autocmd('BufAdd', { group = group, pattern = '*.ipynb', callback = import_output })
    vim.api.nvim_create_autocmd('BufEnter', {
        group = group,
        pattern = '*.ipynb',
        callback = function(e)
            if vim.api.nvim_get_vvar('vim_did_enter') ~= 1 then
                import_output(e)
            end
        end,
    })

    -- jupytext round-trips through markdown, so export back to .ipynb on every save.
    vim.api.nvim_create_autocmd('BufWritePost', {
        group = group,
        pattern = '*.ipynb',
        callback = function()
            if require('molten.status').initialized() == 'Molten' then
                vim.cmd('MoltenExportOutput!')
            end
        end,
    })
end
