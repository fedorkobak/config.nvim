return {
	{
		"neovim/nvim-lspconfig",
		config = function()
            vim.lsp.enable("pyright")
            vim.lsp.enable("ruff")
            vim.lsp.enable("lua_ls")

            vim.keymap.set(
                "n", "E", vim.diagnostic.open_float,
                { desc = "Show diagnostic" }
            )
            vim.keymap.set("n", "gd", vim.lsp.buf.definition)
		end,
	},
    {
        -- The bar at the top of the Python code that shows the class or 
        -- method under the cursor
        "SmiteshP/nvim-navic",
        config = function()
            local navic = require("nvim-navic")
            vim.lsp.config('pyright', {
                on_attach = function(client, bufnr)
                    navic.attach(client, bufnr)
                end
            })
            vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end,
    },
}

