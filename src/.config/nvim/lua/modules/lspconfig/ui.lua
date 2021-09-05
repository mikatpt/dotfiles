local M = {}

function M.symbols_override()
    -- Diagnostic signs
    local diagnostic_signs = {
        Error = '',
        Warning = '',
        Hint = '',
        Information = '',
    }
    for type, icon in pairs(diagnostic_signs) do
        local hl = 'LspDiagnosticsSign' .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
    end
end

return M
