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

| API                           | Purpose                     |
| ----------------------------- | --------------------------- |
| [`vim.o`][vim-o]              | Global options              |
| [`vim.bo`][vim-bo]            | Buffer-local options        |
| [`vim.wo`][vim-wo]            | Window-local options        |
| [`vim.opt`][vim-opt]          | Option manipulation         |
| [`vim.g`][vim-g]              | Global Vim variables (`g:`) |
| [`vim.b`][vim-b]              | Buffer variables (`b:`)     |
| [`vim.w`][vim-w]              | Window variables (`w:`)     |
| [`vim.t`][vim-t]              | Tabpage variables (`t:`)    |
| [`vim.env`][vim-env]          | Environment variables       |
| [`vim.fn`][vim-fn]            | Vimscript functions         |
| [`vim.api`][vim-api]          | Low-level Neovim API        |
| [`vim.keymap`][vim-keymap]    | Key mappings                |
| [`vim.cmd`][vim-cmd]          | Execute Ex commands         |
| [`vim.loop`][vim-loop]        | LibUV interface             |
| [`vim.fs`][vim-fs]            | Filesystem utilities        |
| [`vim.uv`][vim-uv]            | Modern name for LibUV API   |
| [`vim.lsp`][vim-lsp]          | LSP client API              |
| [`vim.diagnostic`][vim-diag]  | Diagnostics API             |

[vim-o]: https://neovim.io/doc/user/lua.html#vim.o
[vim-bo]: https://neovim.io/doc/user/lua.html#vim.bo
[vim-wo]: https://neovim.io/doc/user/lua.html#vim.wo
[vim-opt]: https://neovim.io/doc/user/lua.html#vim.opt
[vim-g]: https://neovim.io/doc/user/lua.html#vim.g
[vim-b]: https://neovim.io/doc/user/lua.html#vim.b
[vim-w]: https://neovim.io/doc/user/lua.html#vim.w
[vim-t]: https://neovim.io/doc/user/lua.html#vim.t
[vim-env]: https://neovim.io/doc/user/lua.html#vim.env
[vim-fn]: https://neovim.io/doc/user/lua.html#vim.fn
[vim-api]: https://neovim.io/doc/user/api.html#API
[vim-keymap]: https://neovim.io/doc/user/lua.html#vim.keymap
[vim-cmd]: https://neovim.io/doc/user/lua.html#vim.cmd()
[vim-loop]: https://neovim.io/doc/user/deprecated.html#vim.loop
[vim-fs]: https://neovim.io/doc/user/lua.html#vim.fs
[vim-uv]: https://neovim.io/doc/user/lua.html#vim.uv
[vim-lsp]: https://neovim.io/doc/user/lsp.html#vim.lsp
[vim-diag]: https://neovim.io/doc/user/diagnostic.html#vim.diagnostic

The `vim.o.runtimepath`/`vim.o.rtp` variable determines where nvim looks for executable scripts.

Check more in the corresponding [API](lua/API.md) page.
