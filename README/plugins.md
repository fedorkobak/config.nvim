# Plugins

The `echo nvim_list_runtime_paths()` command lists where nvim looks for the `lua` folder to load `lua` code (in particular plugins) from.

The plagins makes nvim experience really valuable. There are package managers, I'm using [Lazy](https://lazy.folke.io/).

Check the [installation](https://lazy.folke.io/installation) guide.

In the Lazy configuration file of the lazy (`~/.config/nvim/lua/lazy`), find the line that sets up lazy:

```lua
require("lazy").setup({
  spec = {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  },
  install = { },
  checker = { enabled = true },
})
```

You have to list you plugins in the `spec` parameter.

## Telescope

Is a great plugin that allows to search for the files within the project.

- `Telescope find_files` to look for the files in project. Mapped to `<C-p>`.
- `Telescope regiesters` to view the contents of the registers.

Open the searched result in a **new split or tab**:

- `<C-x>` to open in a new horizontal split.
- `<C-v>` to open in a new vertical split.
- `<C-t>` to open in a new tab.

## File browser

The filebrowser can be added to neovim using [neo-tree](https://github.com/nvim-neo-tree/neo-tree.nvim) plugin. To be able to see the icons of the files/folders in the files-tree, you have to specify the special font to your terminal I prefer [Lekton nerd font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/Lekton.zip).

**Note.** To install the font copy it's `.ttf` files to the `~/.local/share/fonts`.

To open the file browser use the command `:Neotree filesystem reveal left`. Or add the keymap `vim.keymap.set('n', '<C-b>', ":Neotree filesystem reveal left<CR>", {})`.

## Molten

Is a plugin that implements jupyter client inside the nvim.

Check [molten-nvim](https://github.com/benlubas/molten-nvim/tree/main) github repo.

**Note** python runtime you're running molten in must have installed `pynvim` and `jupyter_client` packages.
