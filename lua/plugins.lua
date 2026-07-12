return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local builtin = require("telescope.builtin")
            local search = function()
                builtin.find_files({ hidden = true, no_ignore = true })
            end
            vim.keymap.set("n", "<C-p>", search, {})
        end,
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        config = function()
            vim.keymap.set("n", "<C-b>", ":Neotree filesystem reveal left<CR>", {})
            require("neo-tree").setup({
                  filesystem = {
                    filtered_items = {
                      visible = true,
                      hide_dotfiles = false,
                      hide_gitignored = false,
                    },
                },
            })
        end,
    },
    {
        "akinsho/toggleterm.nvim",
        config = function()
            -- Some terminal emulators do not support the "`" symbol. In the
            -- default ubuntu emualator, `<C-`>` is equivalent to the <C-Space>
            local open_mappings = {"<C-`>", "<C-Space>"}
            require("toggleterm").setup{
                open_mapping = open_mappings,
                direction = "horizontal",
                size = 12,
                insert_mappings = true,
                terminal_mappings = true,
            }
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            vim.keymap.set(
                "n",
                "<C-g>",
                function()
                    require("gitsigns").preview_hunk_inline()
                end,
                { desc = "Git preview hunk" }
            )
        end,
    },
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            dap.adapters.python = {
                type = "executable",
                command = "python",
                args = { "-m", "debugpy.adapter" },
            }

            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    console = "integratedTerminal",
                },
                {
                    type = "python",
                    request = "launch",
                    name = "unittest",
                    module = "unittest",
                    args = { "${file}" },
                    console = "integratedTerminal",
                },
            }

            vim.keymap.set("n", "<Up>", dap.continue)
            vim.keymap.set("n", "<Down>", dap.step_over)
            vim.keymap.set("n", "<Right>", dap.step_into)
            vim.keymap.set("n", "<Left>", dap.step_out)

            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<leader>dr", dap.repl.open)

        end,
    },
}
