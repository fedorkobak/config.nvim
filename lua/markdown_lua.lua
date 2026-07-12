local M = {}

local OUTPUT_START = "<!-- nvim-lua-output:start -->"
local OUTPUT_END = "<!-- nvim-lua-output:end -->"

local function parse_opening_fence(line)
    local indent, fence, language = line:match("^(%s*)(`+)%s*(.-)%s*$")

    if not fence or #fence < 3 or language ~= "lua" then
        return nil
    end

    return indent, fence
end

local function is_closing_fence(line, opening_fence)
    local fence = line:match("^%s*(`+)%s*$")
    return fence ~= nil and #fence >= #opening_fence
end

---Find the fenced Lua block containing a buffer line.
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
        local indent, opening_fence = parse_opening_fence(lines[opening_line])

        if opening_fence then
            for closing_line = opening_line + 1, #lines do
                if is_closing_fence(lines[closing_line], opening_fence) then
                    if row <= closing_line then
                        local code_lines = vim.list_slice(lines, opening_line + 1, closing_line - 1)

                        return {
                            bufnr = bufnr,
                            code = table.concat(code_lines, "\n"),
                            indent = indent,
                            opening_line = opening_line,
                            closing_line = closing_line,
                        }
                    end

                    break
                end
            end
        end
    end

    return nil, "Cursor is not inside a fenced ```lua block"
end

local function pack(...)
    return { n = select("#", ...), ... }
end

local function format_value(value)
    if type(value) == "string" then
        return value
    end

    return tostring(value)
end

local function join_values(values, first, last)
    local formatted = {}

    for index = first, last do
        formatted[#formatted + 1] = format_value(values[index])
    end

    return table.concat(formatted, "\t")
end

local function compile(code, chunk_name, environment)
    if loadstring then
        local chunk, compile_error = loadstring(code, chunk_name)

        if chunk and setfenv then
            setfenv(chunk, environment)
        end

        return chunk, compile_error
    end

    return load(code, chunk_name, "t", environment)
end

---Compile and execute Lua code with access to Neovim's global environment.
---Calls to print are captured as output lines, returned values are appended with
---an "=>" prefix, and compilation or runtime errors are included in the output.
---@param code string Lua source code to execute.
---@param chunk_name string Name used to identify the chunk in error messages.
---@return string[] output Captured output and execution results.
---@return boolean success Whether the code compiled and completed without an error.
local function run(code, chunk_name)
    local output = {}
    
    -- Changing the behaviour of the print function in the compiled
    -- code of the block
    local environment = setmetatable({
        print = function(...)
            local values = pack(...)
            output[#output + 1] = join_values(values, 1, values.n)
        end,
    }, { __index = _G })

    local chunk, compile_error = compile(code, chunk_name, environment)
    if not chunk then
        return { "Error: " .. compile_error }, false
    end

    local result = pack(pcall(chunk))
    if not result[1] then
        output[#output + 1] = "Error: " .. tostring(result[2])
        return output, false
    end

    if result.n > 1 then
        output[#output + 1] = "=> " .. join_values(result, 2, result.n)
    end

    if #output == 0 then
        output[1] = "(no output)"
    end

    return output, true
end

local function split_output_lines(output)
    local lines = {}

    for _, value in ipairs(output) do
        local value_lines = vim.split(value, "\n", { plain = true, trimempty = false })
        vim.list_extend(lines, value_lines)
    end

    return lines
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

local function render_output(output, indent)
    local value_lines = split_output_lines(output)
    local fence = output_fence(value_lines)
    local lines = {
        indent .. OUTPUT_START,
        indent .. fence .. "text",
    }

    for _, line in ipairs(value_lines) do
        lines[#lines + 1] = indent .. line
    end

    lines[#lines + 1] = indent .. fence
    lines[#lines + 1] = indent .. OUTPUT_END

    return lines
end

local function output_range(block)
    local lines = vim.api.nvim_buf_get_lines(block.bufnr, 0, -1, false)
    local first_output_line = block.closing_line + 1

    if vim.trim(lines[first_output_line] or "") ~= OUTPUT_START then
        return block.closing_line, block.closing_line
    end

    local opening_fence = (lines[first_output_line + 1] or ""):match("^%s*(`+)text%s*$")
    if not opening_fence or #opening_fence < 3 then
        return block.closing_line, block.closing_line
    end

    for line_number = first_output_line + 2, #lines do
        if is_closing_fence(lines[line_number], opening_fence)
            and vim.trim(lines[line_number + 1] or "") == OUTPUT_END
        then
            return block.closing_line, line_number + 1
        end
    end

    return block.closing_line, block.closing_line
end

---Execute the fenced Lua block under the cursor and write its output after it.
---@param bufnr? integer
---@param row? integer
---@return boolean success
function M.execute_block(bufnr, row)
    local block, parse_error = M.parse_block(bufnr, row)
    if not block then
        vim.notify(parse_error, vim.log.levels.ERROR)
        return false
    end

    if not vim.bo[block.bufnr].modifiable then
        vim.notify("Cannot write Lua output: buffer is not modifiable", vim.log.levels.ERROR)
        return false
    end

    local chunk_name = ("@markdown-lua:%d-%d"):format(block.opening_line, block.closing_line)
    local output, success = run(block.code, chunk_name)
    local replace_start, replace_end = output_range(block)

    vim.api.nvim_buf_set_lines(
        block.bufnr,
        replace_start,
        replace_end,
        false,
        render_output(output, block.indent)
    )

    return success
end

---Create the :LuaBlock command.
---@param options? { command?: string }
function M.setup(options)
    options = options or {}
    local command = options.command or "LuaBlock"

    vim.api.nvim_create_user_command(command, function()
        M.execute_block()
    end, {
        desc = "Execute the fenced Lua block under the cursor",
        force = true,
    })
end

return M
