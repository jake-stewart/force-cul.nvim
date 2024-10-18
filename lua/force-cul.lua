local M = {}

local lookup = {}

local function createHl(groupName)
    local newHl = {}
    local hl = vim.api.nvim_get_hl(0, {
        name = groupName,
        link = false,
    })
    if hl then
        for k, v in pairs(hl) do
            newHl[k] = v
        end
    end
    local culHl = vim.api.nvim_get_hl(0, {
        name = "CursorLineSign",
        link = false,
    })
    if culHl then
        for k, v in pairs(culHl) do
            newHl[k] = v
        end
    end
    local culhl = groupName .. "ForceCul"
    vim.api.nvim_set_hl(0, culhl, newHl)
    lookup[groupName] = culhl
    return culhl
end

function M.forceUpdate()
    for k in pairs(lookup) do
        createHl(k)
    end
end

function M.setup()
    local origSetmark = vim.api.nvim_buf_set_extmark
    function vim.api.nvim_buf_set_extmark(buffer, ns_id, line, col, opts)
        if opts and opts.sign_text and not opts.cursorline_hl_group then
            local culhl
            local groupName = opts.sign_hl_group or opts.hl_group
            if groupName then
                culhl = lookup[groupName] or createHl(groupName)
            else
                culhl = "CursorLineSign"
            end
            opts.cursorline_hl_group = culhl
        end
        return origSetmark(buffer, ns_id, line, col, opts)
    end

    vim.api.nvim_create_augroup("ForceCul", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        group = "ForceCul",
        callback = M.forceUpdate
    })
end

return M
