return {
	{"L3MON4D3/LuaSnip",},
	{"hrsh7th/nvim-cmp"},
    {
        "hrsh7th/cmp-nvim-lsp",
        config = function()
            local cmp = require("cmp")

            cmp.setup({
              completion = {
                autocomplete = { cmp.TriggerEvent.TextChanged },
              },

              mapping = cmp.mapping.preset.insert({
                ["<CR>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<Tab>"] = cmp.mapping.select_next_item(),
                ["<S-Tab>"] = cmp.mapping.select_prev_item(),
              }),

              sources = {
                { name = "nvim_lsp" },
              },
            })
        end,
    },
}
