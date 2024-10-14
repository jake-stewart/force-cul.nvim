local forceCulGroup = "ForceCul"

local state = {
    prevMarkId = nil,
    prevSignId = nil,
    prevSignGroup = nil,
    prevLine = nil,
    prevBufnr = nil,
    nsid = nil,
}

local function deletePreviousMark()
    if state.prevMarkId then
        vim.api.nvim_buf_del_extmark(
            state.prevBufnr, state.nsid, state.prevMarkId)
    end
    state.prevMarkId = nil
    state.prevSignId = nil
    state.prevSignGroup = nil
    state.prevLine = nil
    state.prevBufnr = nil
end

local function update()
    local line = vim.fn.line(".")
    local bufnr = vim.fn.bufnr()
    local result = vim.fn.sign_getplaced(bufnr, {
        group = "*",
        lnum = line
    })[1]
    local sign
    for _, candidate in ipairs(result.signs) do
        if candidate.group ~= forceCulGroup then
            sign = candidate
            break
        end
    end
    if (not sign) or (not sign.group) or (sign.group == "") then
        deletePreviousMark()
        return
    end
    if sign.group == state.prevSignGroup
        and line == state.prevLine
        and bufnr == state.prevBufnr
        and sign.id == state.prevSignId
    then
        return
    end
    local signNsid = vim.api.nvim_create_namespace(sign.group)
    local mark = vim.api.nvim_buf_get_extmark_by_id(
        bufnr, signNsid, sign.id, { details = true })
    if not mark or mark[1] + 1 ~= line then
        deletePreviousMark()
        return
    end
    local details = mark[3]
    if not details.sign_text
        or details.sign_text == ""
    then
        deletePreviousMark()
        return
    end
    deletePreviousMark()
    state.prevLine = line
    state.prevBufnr = bufnr
    state.prevSignGroup = sign.group
    state.prevSignId = sign.id
    local newHl = {}
    if details.sign_hl_group then
        local hl = vim.api.nvim_get_hl(0, {
            name = details.sign_hl_group,
            link = false,
        })
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
    local newHlGroup = details.sign_hl_group .. "ForceCul"
    vim.api.nvim_set_hl(0, newHlGroup, newHl)
    local opts = {
        sign_text = details.sign_text,
        sign_hl_group = newHlGroup,
        priority = math.min(sign.priority + 1, 65535)
    }
    state.prevMarkId = vim.api.nvim_buf_set_extmark(
        bufnr, state.nsid, line - 1, 0, opts)
end

local M = {}

function M.setup()
    vim.api.nvim_create_augroup(forceCulGroup, { clear = true })
    state.nsid = vim.api.nvim_create_namespace(forceCulGroup)
    vim.api.nvim_create_autocmd("SafeState", {
        group = forceCulGroup,
        pattern = "*",
        callback = update
    })
end

function M.forceUpdate()
    deletePreviousMark()
    update()
end

return M
