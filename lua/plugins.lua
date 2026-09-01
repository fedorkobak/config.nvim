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

            -- search by filename
            local name_search = function()
                builtin.find_files({ hidden = true, no_ignore = true })
            end
            vim.keymap.set("n", "<C-p>", name_search, {})

            -- search by the file content
            local live_grep = function()
                builtin.live_grep({ hidden = true, no_ignore = true })
            end
            vim.keymap.set("n", "<S-p>", live_grep, {})

            -- the commands navigation managed by telescope
            vim.keymap.set("n", ";", builtin.commands)

            -- commands for not so common to use features
            vim.api.nvim_create_user_command("TelSearchHistory", builtin.search_history, {})
            vim.api.nvim_create_user_command("TelBuffers", builtin.buffers, {})
            vim.api.nvim_create_user_command("TelOldFiles", builtin.oldfiles, {})
            vim.api.nvim_create_user_command("TelGitStatus", builtin.git_status, {})
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
        opts = {
            open_mapping = {"<C-`>", "<C-Space>"},
            direction = "horizontal",
            size = 30,
            persist_size = false,
            insert_mappings = true,
            terminal_mappings = true,
        }
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
    -- {
    --     "git@github.com:fedorkobak/md_runner.nvim.git",
    --     config = function()
    --         local md_runner = require("md_runner")
    --         md_runner.setup({
    --             log_level = vim.log.levels.WARNING,
    --         })
    --     end
    -- },
}
