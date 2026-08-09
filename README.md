# `nvim` config

This folder contains my neovim configuration.

This file contains useful links and tips on configuration and usage.

Check:
- The [user docs](https://neovim.io/doc/user/) in the official neovim site.
- The [user manual](https://neovim.io/doc/user/usr_toc/#user-manual).

## Configuration

The default **configuration file** is `~/.config/nvim/init.lua`. NVim executes content of this file every time it starts.

The specific file is configurable:

- The `$MYVIMRC` contains the information about the init files used for this session. NVim constructs it from the `"~/.config"` path and value of the `$NVIM_APPNAME` variable.
- The `$NVIM_APPNAME` specifies which folder in system contains the configuration of the nvim.

Reload configuration with `source $MYVIMRC`.

**Note** use the `.venv` script to configure nvim to load its configuration from this folder for immediate experimentation.

Some basic configuration options:

- `vim.cmd("set expandtab")`: use spaces instead of tab.
- `vim.opt.clipboard = 'unnamedplus'` to only use the system clipboard and omit the internal vim configuration.
- `vim.opt.shiftwidth = 4`: amount of spaces to move the selected lines with `CTRL+</>`.
- `vim.opt.tabstop = 4`: amount of spaces to insert when the TAB is pressed in edit mode.

### Custom config

To start nvim with custom a config use `nvim -u <config file>`. This option bypasses the default configuration file and uses the custom file to load the configuration. This is usefull if you want to experiment with different configuration options without being influenced by the default configuration file.

**Note** It's typically not enough to sepcify just the config script. If the script has any requirements from the current folder, nvim simply cannot load them as they are not added to the runtimepath.

For example, to try the actual configuration for this setup run `nvim -u scripts/dev_init.lua`.

## Windows

Nvim can handle multiple documents simultaneously with buffers, windows, and tabs.

See the dedicated [Windows guide](README/windows.md) for buffer commands, split management, resizing, and tab navigation.

## Modes

**Visual** the mode in which you can select some text. It supports following features:

- **Blocked Visual Mode**: activate blocked visual mode with the capital letter `V` and you will be able to select individual columns rather than whole lines.
- **Move inside selected**: if you need to select more on the other side of the selection, there is no need to recreate the visual block. Just move to the end with the `o` letter.

**Visual blocked** is a variation of the visual mode that allows you to select a block of text without having to select each line up to the end. This approach provides some features associated with completing repetative oparations on the different lines:

- Enter insert mode with `I` and text added in the first line would be added in all lines.
- Entering insert mode with `A` works the same but insert new text at the right sight of the selected area. 
- With `c` command the selected block would be removed, and the typed text would be substituted in the each line.

**Terminal**

- To open terminal use `:terminal` command.
- To start typing enter the edit mode, as usualy using `i`.
- To return to normal mode use `<C-\>,<C-n>` by default (Changed to `<C-w><Esc>` in my configuration).
- This configuration uses [`akinsho/toggleterm.nvim`](https://github.com/akinsho/toggleterm.nvim) plugin to manage terminal. Open the toggleterm with ```<C-`>``` command (which is for unknown reason is equivalent to the `<C-Space>`).

**Replacing**

Enter the replacing mode with the capital `R`. All characters you type, replace the characters under the cursor.

## Vim motions

Vim motions are the main navigation system for moving through text efficiently.

See the dedicated [Vim motions guide](README/vim-motions.md) for movement tricks, jumps, and macros.

## Shortcuts

You are supposed to configure the shortcuts for the nvim editor.

Do this with lua function command:

```lua
vim.keymap.set(mode, shortcut, command)
```

Where:

- `mode`: modes where the shortcut would be available (`n`, `e`, `v` etc.). 
- `shortcut`: the shortcut you want to set up.
- `command`: the command the shortcut will execute.

**Special keys** are shortcuts that are usually wrapped in `<>` brackets. The following table shows the denotations for common keys used in key combinations.

| Key          | Notation        |
| ------------ | --------------- |
| Enter        | `<CR>`          |
| Escape       | `<Esc>`         |
| Tab          | `<Tab>`         |
| Backspace    | `<BS>`          |
| Space        | `<Space>`       |
| Leader key   | `<leader>`      |
| Local leader | `<localleader>` |

**Modifier keys** The Ctrl, Alt and Shift keys are considered as modifyer keys, so they can only be used in combination with other keys. They must be refereneced as follows: `<C-{key}>`, `<A-{key}>`, `<S-{key}>`.

| Key          | Notation        |
| ------------ | --------------- |
| Shift        | `<S+{key}>`     |
| Ctrl         | `<C+{key}>`     |
| Alt          | `<A+{key}>`     |


**Note**. In shortcuts you can use the special `<leader>` key, which is the special key for shortcuts configured for this user. By default, the `<leader>` is equivalent to space.

## Registers

Vim contains several clipboards, which are called 'registers'. They have names composed of one symbol. The default register is named `"`, and anything that is yanked, deleted or replaced appeared in this register.

You can select the registry to use by entering a command that begins with the `"` symbol. Then specify the registry you want to use and the specific command you want to apply:

For example:

- `"1y` to yank the text to the register called `1`.
- `"1p` to pase the text from the register called `1`.

This would work with any command related with copying/pasting.

Check the "Using registers" seciton of the [Copy text between files](https://neovim.io/doc/user/usr_07/#07.5) chapter of the vim manual.

The [telescope](https://github.com/nvim-telescope/telescope.nvim) has a great feature for the registers. View your registers with the `:Telescope registers` command.

## Lua

Lua is used to configure and extend Neovim through the `vim` runtime API.

For more check:

- Offiial [Lua guide](https://neovim.io/doc/user/lua-guide/) to start using lua in nvim.
- The [Lua](https://neovim.io/doc/user/lua/#lua-vim-system) runtime reference.
- [Lua](README/lua.md) page for runtime path notes, running Lua snippets, and the Neovim API table.

## LSP

Neovim supports the lsp features check the [documentaion](https://neovim.io/doc/user/lsp.html).

### Configuration

The important things to know for configuring the LSP in nvim:

- `nvim.lsp.config`: table allows to change/extend the configuration of LSP servers.
- [`vim.lsp.enable`][vim.lsp.enable]: function includes the server to the runtime. It can take configurations from:
    - `nvim.lsp.config` if they are defined there.
    - **Runtime path** can contain files with LSPs configuration. The [`neovim/nvim-lspconfig`][nvim-lspconfig] plugins is essential here - adds the configs for the most popular LSP server to the runtime path.

[vim.lsp.enable]: https://neovim.io/doc/user/lsp.html#vim.lsp.enable()
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig

### Usage

Monitoring/management of the serveers:

- **Restart** the LSP use command `:lsp restart`.
- **Check state** of the lsp server with command `:checkhealth vim.lsp`.

Some important commands:

- [`vim.lsp.buf.definition`](https://neovim.io/doc/user/lsp.html#vim.lsp.buf.definition()) go to the definition of the given object (`gd` in this configuration is mapped for this command).
- [`vim.lsp.buf.type_definition`](https://neovim.io/doc/user/lsp.html#vim.lsp.buf.type_definition()) jumps to the definition of the type of the object under cursor (`grt` default shortcut).
- [`vim.lsp.buf.references`](https://neovim.io/doc/user/lsp.html#vim.lsp.buf.references()) shows all the mentions of the symbol under cursor in the special window (`grr` default shortcut).
- [`vim.lsp.buf.hover`](https://neovim.io/doc/user/lsp.html#vim.lsp.buf.hover()) shows a hover window that contains the information about the symbol under the cursor (`K` to show the hover, `KK` to enter the hover and navigate inside it like in regular window).
- [`vim.diagnostics.open_float`](https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.open_float()) opens the show diagnostics in the floating window. This means that if lsp or formatter marked some problem you can get additional inforamation in the floating window. The `<shit-e>` is mapped to this opperation in configuration.

## Plugins

Plugins are managed with [Lazy](https://lazy.folke.io/) and provide most of the editor extensions used by this configuration.

See the dedicated [Plugins guide](README/plugins.md) for Lazy setup, Telescope, and file browser notes.

## Search and substitute

Vim has built-in search and substitution commands for navigating matches and replacing text by pattern.

See the dedicated [Search and substitute guide](README/search-and-substitute.md) for search syntax, word boundaries, replacement ranges, and substitution flags.

## Debugger

The way to use debugger with neovim is by using [`nvim-dap`](https://github.com/mfussenegger/nvim-dap) plugin.

This configuration uses:

- `<leader>dc`, `<leader>dn`, `<leader>di`, `<leader>do`: continue, step over, step into and step out respectively.
- `<leader>b` to set the break point.
- `<leader>dr` opens the dap window, where you can type the variables whose values you want to inspect.

A terminal is automatically created for each debugging session. It stores messages from the processe's stdout. Use the `:ls` command to show all available buffers; the buffer created for the DAP will have the `[dap-terminal]` in it's name. Use the command `:b <number>` to open the corresponding buffer.

**Note.** The [`debugpy`](https://github.com/microsoft/debugpy) have to be installerd in the environment to use dap.

## vimscrip configuration

Sometimes it's useful to have the same configuration in vimscrip style rather than lua style. This is useful as some other tools contain facilities to build vim-like workflows and they sometimes the vim scirpt. So here is listed configuration for vim-script that I use:

```vim
set relativenumber
set clipboard=unnamedplus
```
