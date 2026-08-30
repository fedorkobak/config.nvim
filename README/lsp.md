# LSP

This section considers the details of the lsp configuration.

## Configuration

The important things to know for configuring the LSP in nvim:

- `nvim.lsp.config`: table allows to change/extend the configuration of LSP servers.
- [`vim.lsp.enable`][vim.lsp.enable]: function includes the server to the runtime.
  It can take configurations from:
    - `nvim.lsp.config` if they are defined there.
    - **Runtime path** can contain files with LSPs configuration.
      The [`neovim/nvim-lspconfig`][nvim-lspconfig] plugins is essential here -
      adds the configs for the most popular LSP server to the runtime path.

[vim.lsp.enable]: https://neovim.io/doc/user/lsp.html#vim.lsp.enable()
[nvim-lspconfig]: https://github.com/neovim/nvim-lspconfig

## Usage

Monitoring/management of the serveers:

- **Restart** the LSP use command `:lsp restart`.
- **Check state** of the lsp server with command `:checkhealth vim.lsp`.

Some important commands:

- [`vim.lsp.buf.definition`][vim.lsp.buf.definition] go to the definition of the
given object (`gd` in this configuration is mapped for this command).
- [`vim.lsp.buf.type_definition`][vim.lsp.buf.type_definition] jumps to the
definition of the type of the object under cursor (`grt` default shortcut).
- [`vim.lsp.buf.references`][vim.lsp.buf.references] shows all the mentions of
the symbol under cursor in the special window (`grr` default shortcut).
- [`vim.lsp.buf.hover`][vim.lsp.buf.hover] shows a hover window that contains
the information about the symbol under the cursor (`K` to show the hover, `KK`
to enter the hover and navigate inside it like in regular window).
- [`vim.diagnostics.open_float`][vim.diagnostic.open_float] opens the show
diagnostics in the floating window. This means that if lsp or formatter marked
some problem you can get additional inforamation in the floating window. The
`<shit-e>` is mapped to this opperation in configuration.

[vim.lsp.buf.definition]: https://neovim.io/doc/user/lsp.html#vim.lsp.buf.definition()
[vim.lsp.buf.type_definition]: https://neovim.io/doc/user/lsp.html#vim.lsp.buf.type_definition()
[vim.lsp.buf.references]: https://neovim.io/doc/user/lsp.html#vim.lsp.buf.references()
[vim.lsp.buf.hover]: https://neovim.io/doc/user/lsp.html#vim.lsp.buf.hover()
[vim.diagnostic.open_float]: https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.open_float()
