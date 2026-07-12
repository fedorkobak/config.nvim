vim.opt.clipboard = 'unnamedplus'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- indentations settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Terminal setup
vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k")
vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-w><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-w>L", "<C-w>l", { remap = true })
vim.keymap.set("n", "<C-w>H", "<C-w>h", { remap = true })
vim.keymap.set("n", "<C-w>J", "<C-w>j", { remap = true })
vim.keymap.set("n", "<C-w>K", "<C-w>k", { remap = true })

-- Plugins
require('config.lazy')

-- Execute fenced code blocks in Markdown.
local lua_md_runner = require("markdown_lua")
local molten_md_runner = require("markdown_molten")

lua_md_runner.setup()
molten_md_runner.setup()

vim.keymap.set("n", "<C-n>", lua_md_runner.execute_block, { desc = "Execute Markdown Lua block" })
vim.keymap.set("n", "<leader>mr", molten_md_runner.execute_block, {
    desc = "Execute Markdown block with Molten and insert output",
})
