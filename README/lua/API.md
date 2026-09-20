<!-- md-runner
{
  "executors": {
    "lua": {
      "module": "md_runner.executors.nvim_lua"
    }
  }
}
-->
# API

This page considers the details of using different features of the lua api.

## `vim.opt`

The `vim.opt` is designed to maniplate with options.

By using the `append`, `prepend`, `remove` methods of the subtables, the
configuration can be changed more easily than by accessing it directly using the
`vim.o` API.

For example the code:

```lua
print(vim.o.rtp:sub(1,50))
```

<!-- md-runner-output:start -->

```text
/home/fedor/.config/nvim,/home/fedor/.local/share/
```

<!-- md-runner-output:end -->

Just prints the runtime path. However, it is a string type, so to edit it you need
to implement concatenation/search/remove... operations by yourself.

The `vim.opt.rtp` allows this to be done automatically. For example, the following
code adds the `/tmp` path at the beginning of the Lua runtime path:

```lua
vim.opt.rtp:prepend("/tmp")
print(vim.o.rtp:sub(1, 50))
```

<!-- md-runner-output:start -->

```text
/tmp,/home/fedor/.config/nvim,/home/fedor/.local/s
```

<!-- md-runner-output:end -->

The corresponding change appears in the `vim.o.rtp` because they are different
interfaces for the same parameter.

## `vim.api`

NVim exposes a general low-level API. You can access it in Lua code through the
`vim.api` table.

Check more in the [Api](https://neovim.io/doc/user/api/#API) page of the documentation.

---

For example, the following cell uses the function `nvim_get_current_buf()` to
retrieve the index and the function `nvim_buf_get_lines` to retrieve the first few
lines of the buffer:

```lua
curr_buffer = vim.api.nvim_get_current_buf()
print("buffer number:", curr_buffer)

local output = vim.api.nvim_buf_get_lines(curr_buffer, 0, 3, false)

for _, v in ipairs(output) do
    print(v)
end
```

<!-- md-runner-output:start -->

```text
buffer number: 6
<!-- md-runner
{
  "executors": {
```

<!-- md-runner-output:end -->

The result is literally the first lines of this document, because code was
executed while the document was edited.

## `vim.fn`

The api provides the access to the classical vim built-in functions from lua code.

The most widely used built-in funcitons are:

- **`vim.fn.expand()`** – Expands special filename modifiers and wildcards.
  Commonly used to get the current file (`%`), current directory (`%:h`), absolute
  path (`%:p`), or home directory (`~`).

- **`vim.fn.getline()`** – Retrieves one or more lines from the current buffer or
  a specified buffer. Frequently used by plugins that inspect or process the
  current document.

- **`vim.fn.mode()`** – Returns the current editor mode (e.g. `"n"` for Normal,
  `"i"` for Insert, `"v"` for Visual). Useful for adapting plugin behavior to the
  user's current interaction.

- **`vim.fn.input()`** – Displays a prompt and waits for user input. Commonly used
  by plugins to ask for filenames, search terms, commands, or other parameters.

- **`vim.fn.system()`** – Executes an external shell command and returns its
  standard output as a string. Often used to integrate with tools such as Git,
  ripgrep, or language-specific utilities.

Check the details in the [Neovim documentation](https://neovim.io/doc/user/vimfn/).

### fnamemodify

The popular function allows transformate filepaths.

Check the [fnamemodiry](https://neovim.io/doc/user/vimfn/#fnamemodify()) funciton description.

**Note**: the official reference recommends using the dedicated functions from
the new `vim.fs` API.

---

The following example shows how to add an apsolute path to file:

```lua
print(vim.fn.fnamemodify("example.txt", ":p"))
```

<!-- md-runner-output:start -->

```text
/home/fedor/Documents/code/config.nvim/example.txt
```

<!-- md-runner-output:end -->

## `vim.system`

The `vim.system` is a function that allows to run the command in the system's cmd.

A few object have been defined to manage processes spawned by the `vim.system`:

- `vim.SystemCompleted`: the output of the system command.
- `vim.SystemObj`: this object represents process and allows you to manipulate it.

Check more in the [Lua module: vim.system](https://neovim.io/doc/user/lua/#lua-vim-system)
section of the nvim documentation.

---

The following cell spawns the process. It calls the `wait` method to wait until
the process is complete, and then retrieves the process output.

```lua
local obj = vim.system({"echo", "output of the command line"})
local complted = obj:wait()
print(complted.stdout)
```

<!-- md-runner-output:start -->

```text
output of the command line

```

<!-- md-runner-output:end -->

For a change the output of the `docker ps` command:

```lua
local obj = vim.system({"docker", "ps"}):wait()
print(obj.stdout)
```

<!-- md-runner-output:start -->

```text
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

```

<!-- md-runner-output:end -->

### `SystemObj`

The [`SystemObj`](https://neovim.io/doc/user/lua/#vim.SystemObj) object keeps the information
about the process that is still running.

The methods are:

- `is_closing`: checks if process finishing or finished.
- `kill`: kills the process.
- `wait`: blocks the main thread and waits untill process finish.
- `write`: writes to the stdin of the process. **Note** `vim.system` has to be
  called with `stdin = true` parameter.

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

<!-- md-runner-output:start -->

```text
hello
=== ls command ===
init.lua
lua
nvim.log
README
README.md
rumdl.toml
scripts
setup.sh

```

<!-- md-runner-output:end -->

### Callbacks

The behaviour when the process outputs to stderr or stdout can be controlled
by defining the corresponding callback.

---

The following cell starts the bash session. The `stdout` and `stderr` callbacks
are passed to the `vim.system` call. These callbacks accumulate the information
fetched from the corresponding streams into the `output_data` variable:

```lua

local output_data = ""

local obj = vim.system({ "bash" }, {
    stdin = true,
    stdout = function(err, data)
        if data then
            output_data = output_data .. "[stdin]" .. data .. "[stdin]" .. "\n"
        else
            output_data = output_data .. "stdout closed" .. "\n"
        end
    end,
    stderr = function(err, data)
        if data then
            output_data = output_data .. "[stderr]" .. data .. "[stderr]" .. "\n"
        else
            output_data = output_data .. "stderr closed" .. "\n"
        end
    end
})

obj:write("echo -n message_to_stdin\n")
obj:write("echo -n message_to_stderr >& 2\n")
obj:write(nil)

completed = obj:wait()
print(output_data)

```

<!-- md-runner-output:start -->

```text
[stdin]message_to_stdin[stdin]
[stderr]message_to_stderr[stderr]
stderr closed
stdout closed

```

<!-- md-runner-output:end -->
