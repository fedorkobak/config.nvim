# Lua

Lua is a programming language that allow to manipulate the nvim editor. In fact, all the extentions of nvim are written in this language.

Check the [lua-guide](https://neovim.io/doc/user/lua-guide/) for a basic reference on using lua within Neovim.


## Run

There are several options for running code directly in nvim environment. This is extremely usefull when debugging of the nvim behaviour.

To run a single line of code, use the following command:

```lua
:lua print("hello world")
```

To run code selected in Visual mode, select the code, enter Command-line mode, and add lua after the suggested `'<,'>` range. Command line would look like this:

```vimscript
:'<,'>lua
```

## API

The `NVim` provides some API's in its Lua runtime. These are specific API's to manipulate with editor.

The API is provided through `vim` table:

```lua
print(type(vim))
print(vim)
```
<!-- nvim-lua-output:start -->
```text
table
table: 0x79a67ffea218
```
<!-- nvim-lua-output:end -->

The following table shows the lua subtables that are responsible for various aspects of the editor:

| API              | Purpose                     |
| ---------------- | --------------------------- |
| `vim.o`          | Global options              |
| `vim.bo`         | Buffer-local options        |
| `vim.wo`         | Window-local options        |
| `vim.opt`        | Option manipulation         |
| `vim.g`          | Global Vim variables (`g:`) |
| `vim.b`          | Buffer variables (`b:`)     |
| `vim.w`          | Window variables (`w:`)     |
| `vim.t`          | Tabpage variables (`t:`)    |
| `vim.env`        | Environment variables       |
| `vim.fn`         | Vimscript functions         |
| `vim.api`        | Low-level Neovim API        |
| `vim.keymap`     | Key mappings                |
| `vim.cmd`        | Execute Ex commands         |
| `vim.loop`       | LibUV interface             |
| `vim.fs`         | Filesystem utilities        |
| `vim.uv`         | Modern name for LibUV API   |
| `vim.lsp`        | LSP client API              |
| `vim.diagnostic` | Diagnostics API             |

The `vim.o.runtimepath`/`vim.o.rtp` variable determines where nvim looks for executable scripts.

Check more in the corresponding [API](lua/API.md) page.
