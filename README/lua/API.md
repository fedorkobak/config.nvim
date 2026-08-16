# API

This page considers the details of using different features of the lua api.

## `vim.opt`

The `vim.opt` is designed to maniplate with options.

By using the `append`, `prepend`, `remove` methods of the subtables the configuration can be changed esily that if to acccess to it directly using `vim.o` api.

For example the code:

```lua
print(vim.o.rtp:sub(1,50))
```
<!-- nvim-lua-output:start -->
```text
/home/fedor/.config/nvim,/home/fedor/.local/share/
```
<!-- nvim-lua-output:end -->

Just prints the runtime path. However, it is a string type, so to edit it you need to implement concatenation/search/remove... operations by yourself.

The `vim.opt.rtp` allows this to be done automatically. For example, the following code adds the `/tmp` path at the beginning of the Lua runtime path:

```lua
vim.opt.rtp:prepend("/tmp")
print(vim.o.rtp:sub(1, 50))
```
<!-- nvim-lua-output:start -->
```text
/tmp,/home/fedor/.config/nvim,/home/fedor/.local/s
```
<!-- nvim-lua-output:end -->

The corresponding change appears in the `vim.o.rtp` because they are different interfaces for the same parameter.

## `vim.api`

NVim exposes general low level api. You can access it in lua code through `vim.api` table.

Check more in the [Api](https://neovim.io/doc/user/api/#API) page of the documentation.

---

For example the following cell uses the function `nvim_get_current_buf()` to retrieve the index and the function `nvim_buf_get_lines` the first few lines of the buffer:

```lua
curr_buffer = vim.api.nvim_get_current_buf()
print(curr_buffer)
print(vim.api.nvim_buf_get_lines(curr_buffer, 0, 3, false))
```
<!-- nvim-lua-output:start -->
```text
39
{ "# API", "", "This page considers the details of using different features of the lua api." }
```
<!-- nvim-lua-output:end -->

The result is literally the first lines of this document, because code was executed while the document was edited.

## `vim.fn`

The api provides the access to the classical vim built-in functions from lua code.

The most widely used built-in funcitons are:

* **`vim.fn.expand()`** – Expands special filename modifiers and wildcards. Commonly used to get the current file (`%`), current directory (`%:h`), absolute path (`%:p`), or home directory (`~`).

* **`vim.fn.getline()`** – Retrieves one or more lines from the current buffer or a specified buffer. Frequently used by plugins that inspect or process the current document.

* **`vim.fn.mode()`** – Returns the current editor mode (e.g. `"n"` for Normal, `"i"` for Insert, `"v"` for Visual). Useful for adapting plugin behavior to the user's current interaction.

* **`vim.fn.input()`** – Displays a prompt and waits for user input. Commonly used by plugins to ask for filenames, search terms, commands, or other parameters.

* **`vim.fn.system()`** – Executes an external shell command and returns its standard output as a string. Often used to integrate with tools such as Git, ripgrep, or language-specific utilities.

Check the details in the [neovim](neovim.io/doc/user/vimfn/).

### fnamemodify

The popular function allows transformate filepaths.

Check the [fnamemodiry](https://neovim.io/doc/user/vimfn/#fnamemodify()) funciton description.

**Note**: the official reference recommends using the dedicated functions from the new `vim.fs` API.

---

The following example shows how to add an apsolute path to file:

```lua
print(vim.fn.fnamemodify("example.txt", ":p"))
```
<!-- nvim-lua-output:start -->
```text
/home/fedor/Documents/code/fedorkobak/example.txt
```
<!-- nvim-lua-output:end -->


## `vim.system`

The `vim.system` is a function that allows to run the command in the system's cmd.

A few object have been defined to manage processes spawned by the `vim.system`:

- `vim.SystemCompleted`: the output of the system command.
- `vim.SystemObj`: this object represents process and allows you to manipulate it.

Check more in the [Lua module: vim.system](https://neovim.io/doc/user/lua/#lua-vim-system)
section of the nvim documentation.

---

The following cell spawns the process. It calls the `wait` method to wait until the
process is complete, and then retrieves the process output.

```lua
local obj = vim.system({"echo", "output of the command line"})
local complted = obj:wait()
print(complted.stdout)
```
<!-- nvim-lua-output:start -->
```text
output of the command line

```
<!-- nvim-lua-output:end -->

For a change the output of the `docker ps` command:

```lua
local obj = vim.system({"docker", "ps"}):wait()
print(obj.stdout)
```
<!-- nvim-lua-output:start -->
```text
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

```
<!-- nvim-lua-output:end -->

### `SystemObj`

The [`SystemObj`](https://neovim.io/doc/user/lua/#vim.SystemObj) object keeps the information
about the process that is still running.

The methods are:

- `is_closing`: checks if process finishing or finished.
- `kill`: kills the process.
- `wait`: blocks the main thread and waits untill process finish.
- `write`: writes to the stdit of the process. **Note** the `vim.system` have to be called
with `stdin = true` parameter.

---

The following code illustrates how to spawn a `bash` process and during it's
execution send specific bash commands to it:

```lua
local obj = vim.system({"bash"}, {stdin = true})
obj:write({"echo hello", "echo '=== ls command ==='", "ls"})
obj:write(nil)
local completed = obj:wait()
print(completed.stdout)
```
<!-- nvim-lua-output:start -->
```text
hello
=== ls command ===
init.lua
lua
nvim.log
README
README.md
scripts
setup.sh

```
<!-- nvim-lua-output:end -->
