local M = {}

-- Molten's bundled helper predates Neovim 0.12, where #offset! metadata moved
-- from .range to .offset. Keep output export working without patching the plugin.
M.remove_comments = function(str, lang)
    local parser = vim.treesitter.get_string_parser(str, lang)
    local root = parser:parse()[1]:root()
    local query = vim.treesitter.query.parse(lang, [[((comment) @c (#offset! @c 0 0 0 -1))]])
    local lines = vim.split(str, '\n')

    for _, match, metadata in query:iter_matches(root, str, root:start(), root:end_(), {}) do
        local node = match[1][1]
        local range = vim.treesitter.get_range(node, str, metadata[1])
        local line = range[1] + 1
        lines[line] = string.sub(lines[line], 1, range[2])
    end

    return vim.fn.join(vim.tbl_filter(function(line) return line ~= '' end, lines), '\n')
end

return M
