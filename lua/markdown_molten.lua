local M = {}

local OUTPUT_START = "<!-- molten-output:start -->"
local OUTPUT_END = "<!-- molten-output:end -->"
local POLL_INTERVAL_MS = 100
local TIMEOUT_MS = 5 * 60 * 1000

local namespace = vim.api.nvim_create_namespace("markdown-molten-output")
local pending = {}

local function parse_opening_fence(line)
    local indent, fence, info = line:match("^(%s*)(`+)%s*(.-)%s*$")

    if not fence or #fence < 3 or info == "" then
        return nil
    end

    return indent, fence, info:match("^([^%s{]+)")
end

local function is_closing_fence(line, opening_fence)
    local fence = line:match("^%s*(`+)%s*$")
    return fence ~= nil and #fence >= #opening_fence
end

---Find the fenced Markdown block containing a buffer line.
---@param bufnr? integer Buffer number; defaults to the current buffer.
---@param row? integer One-based line number; defaults to the cursor line.
---@return table|nil block
---@return string|nil error
function M.parse_block(bufnr, row)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    row = row or vim.api.nvim_win_get_cursor(0)[1]

    if not vim.api.nvim_buf_is_valid(bufnr) then
        return nil, "Invalid buffer"
    end

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    if row < 1 or row > #lines then
        return nil, "Cursor is outside the buffer"
    end

    for opening_line = row, 1, -1 do
        local indent, opening_fence, language = parse_opening_fence(lines[opening_line])

        if opening_fence then
            for closing_line = opening_line + 1, #lines do
                if is_closing_fence(lines[closing_line], opening_fence) then
                    if row <= closing_line then
                        if closing_line == opening_line + 1 then
                            return nil, "Cannot execute an empty fenced code block"
                        end

                        return {
                            bufnr = bufnr,
                            indent = indent,
                            language = language,
                            opening_line = opening_line,
                            code_start_line = opening_line + 1,
                            code_end_line = closing_line - 1,
                            closing_line = closing_line,
                        }
                    end

                    break
                end
            end
        end
    end

    return nil, "Cursor is not inside a fenced Markdown code block"
end

local function split_output_lines(lines)
    local output = {}

    -- The first line in a Molten output buffer is its status header.
    for index = 2, #lines do
        local value_lines = vim.split(lines[index], "\n", { plain = true, trimempty = false })
        vim.list_extend(output, value_lines)
    end

    while #output > 0 and output[#output] == "" do
        table.remove(output)
    end

    if #output == 0 then
        return { "(no output)" }
    end

    local has_text = false
    for _, line in ipairs(output) do
        if line:find("%S") then
            has_text = true
            break
        end
    end

    if not has_text then
        return { "(non-text output; see Molten's output window)" }
    end

    return output
end

local function output_fence(lines)
    local longest_run = 0

    for _, line in ipairs(lines) do
        for run_of_backticks in line:gmatch("`+") do
            longest_run = math.max(longest_run, #run_of_backticks)
        end
    end

    return string.rep("`", math.max(3, longest_run + 1))
end

local function render_output(lines, indent)
    local fence = output_fence(lines)
    local rendered = {
        indent .. OUTPUT_START,
        indent .. fence .. "text",
    }

    for _, line in ipairs(lines) do
        rendered[#rendered + 1] = indent .. line
    end

    rendered[#rendered + 1] = indent .. fence
    rendered[#rendered + 1] = indent .. OUTPUT_END

    return rendered
end

local function output_range(bufnr, first_line)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    if vim.trim(lines[first_line + 1] or "") ~= OUTPUT_START then
        return first_line, first_line
    end

    for line_number = first_line + 2, #lines do
        if vim.trim(lines[line_number] or "") == OUTPUT_END then
            return first_line, line_number
        end
    end

    return nil, nil, "Existing Molten output block has no closing marker"
end

local function clear_pending(job)
    if pending[job.bufnr] == job then
        pending[job.bufnr] = nil
    end

    if vim.api.nvim_buf_is_valid(job.bufnr) then
        pcall(vim.api.nvim_buf_del_extmark, job.bufnr, namespace, job.anchor)
    end
end

local function fail(job, message)
    clear_pending(job)
    vim.notify(message, vim.log.levels.ERROR)
end

local function insert_output(job, output_buffer_lines)
    if not vim.api.nvim_buf_is_valid(job.bufnr) then
        clear_pending(job)
        return
    end

    if not vim.bo[job.bufnr].modifiable then
        fail(job, "Cannot insert Molten output: buffer is not modifiable")
        return
    end

    local position = vim.api.nvim_buf_get_extmark_by_id(job.bufnr, namespace, job.anchor, {})
    if #position == 0 then
        fail(job, "Cannot insert Molten output: insertion point was deleted")
        return
    end

    local replace_start, replace_end, range_error = output_range(job.bufnr, position[1])
    if not replace_start then
        fail(job, range_error)
        return
    end

    local output = split_output_lines(output_buffer_lines)
    vim.api.nvim_buf_set_lines(
        job.bufnr,
        replace_start,
        replace_end,
        false,
        render_output(output, job.indent)
    )

    clear_pending(job)
end

local function find_output_buffer(job)
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if not job.existing_buffers[bufnr] and vim.api.nvim_buf_is_valid(bufnr) then
            local ok, filetype = pcall(vim.api.nvim_get_option_value, "filetype", { buf = bufnr })
            if ok and filetype == "molten_output" then
                return bufnr
            end
        end
    end

    return nil
end

local function poll(job)
    if pending[job.bufnr] ~= job then
        return
    end

    if not vim.api.nvim_buf_is_valid(job.bufnr) then
        clear_pending(job)
        return
    end

    if vim.uv.hrtime() - job.started_at > TIMEOUT_MS * 1000000 then
        fail(job, "Timed out waiting for Molten output")
        return
    end

    if not job.output_bufnr or not vim.api.nvim_buf_is_valid(job.output_bufnr) then
        job.output_bufnr = find_output_buffer(job)
    end

    if job.output_bufnr then
        local lines = vim.api.nvim_buf_get_lines(job.output_bufnr, 0, -1, false)
        local header = lines[1] or ""

        if header:find("Done", 1, true) or header:find("Failed", 1, true) then
            insert_output(job, lines)
            return
        end
    end

    vim.defer_fn(function()
        poll(job)
    end, POLL_INTERVAL_MS)
end

local function cancel_pending(bufnr)
    local job = pending[bufnr]
    if job then
        clear_pending(job)
    end
end

---Execute the fenced Markdown block under the cursor through Molten and write
---the completed textual output immediately after the block.
---@param bufnr? integer
---@param row? integer
---@return boolean started
function M.execute_block(bufnr, row)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    row = row or vim.api.nvim_win_get_cursor(0)[1]

    local block, parse_error = M.parse_block(bufnr, row)
    if not block then
        vim.notify(parse_error, vim.log.levels.ERROR)
        return false
    end

    -- Remote-plugin functions are registered lazily and may still report 0
    -- from exists("*MoltenEvaluateRange") before the Python host starts.
    if vim.fn.exists(":MoltenInit") == 0 then
        vim.notify("Molten is unavailable; run :Lazy load molten-nvim", vim.log.levels.ERROR)
        return false
    end

    if not vim.bo[bufnr].modifiable then
        vim.notify("Cannot insert Molten output: buffer is not modifiable", vim.log.levels.ERROR)
        return false
    end

    cancel_pending(bufnr)

    local existing_buffers = {}
    for _, existing_bufnr in ipairs(vim.api.nvim_list_bufs()) do
        existing_buffers[existing_bufnr] = true
    end

    -- The zero-based row equal to closing_line is immediately after the
    -- closing fence, including when the fence is the last line in the file.
    local anchor = vim.api.nvim_buf_set_extmark(bufnr, namespace, block.closing_line, 0, {
        right_gravity = false,
        strict = false,
    })
    local job = {
        anchor = anchor,
        bufnr = bufnr,
        existing_buffers = existing_buffers,
        indent = block.indent,
        started_at = vim.uv.hrtime(),
    }
    pending[bufnr] = job

    local ok, evaluate_error = pcall(
        vim.fn.MoltenEvaluateRange,
        block.code_start_line,
        block.code_end_line
    )
    if not ok then
        fail(job, "Could not start Molten evaluation: " .. tostring(evaluate_error))
        return false
    end

    poll(job)
    return true
end

---Create :MoltenBlock.
function M.setup()
    vim.api.nvim_create_user_command("MoltenBlock", function()
        M.execute_block()
    end, {
        desc = "Execute the fenced Markdown block under the cursor and insert its Molten output",
        force = true,
    })
end

return M
