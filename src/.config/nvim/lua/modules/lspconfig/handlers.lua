local M = {}

-- TODO: I don't think this works anymore, look into it later.

-- Telescope's lsp_implementations always brings up a preview menu, which can be annoying.
-- If there's only one result, we'll just use the built-in lsp function.
local custom_impl = function(err, method, result, client_id, bufnr, config)
    local ft = vim.api.nvim_buf_get_option(bufnr, 'filetype')
    local no_impls_err = 'ERROR: No implementations for this item!'

    if result == nil then
        result = {}
        err = no_impls_err
    end

    if ft == 'go' then
        -- Do not include implementations from mocks or test files in go.
        -- We do two checks to make sure we don't open telescope if not necessary
        local new_result = vim.tbl_filter(function(v)
            return not string.find(v.uri, 'mock') and not string.find(v.uri, 'test')
        end, result)

        if #new_result > 0 then
            result = new_result
        end

        if #new_result > 1 then
            require('telescope.builtin').lsp_implementations({
                layout_strategy = 'vertical',
                file_ignore_patterns = { '*mock*/*', '**/*mock*', '*test*/*', '**/*test*' },
            })
            return
        end
    else
        if type(result) == 'table' and #result > 1 then
            require('telescope.builtin').lsp_implementations({ layout_strategy = 'vertical' })
            return
        end
    end

    if result == nil or (type(result) == 'table' and #result == 0) then
        err = no_impls_err
    end

    vim.lsp.handlers['textDocument/implementation'](err, method, result, client_id, bufnr, config)
    vim.cmd([[normal! zz]])
end

M.implementation = function()
    local params = vim.lsp.util.make_position_params()

    vim.lsp.buf_request(0, 'textDocument/implementation', params, custom_impl)
end

return M
