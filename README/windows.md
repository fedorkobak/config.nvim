# Windows

Nvim can handle multiple documents simualtaneosly. This is achieved through the following features:

- **Buffers**: the representation of the file in nvim.
- **Window**: represents the buffer in interface.
- **Tab**: the collection of the windows.

Check the [Windows](https://neovim.io/doc/user/windows/) section of the user manual.

## Buffers

In vim buffers are in-memory representations of files or content. Bufferes are:

- Each file you've opened with nvim.
- The terminal sessions.

The following nvim commands are associated with buffers:

- `:ls`: list available buffers.
- `:buffer <number>` or `b <number>`: to open the corresponding buffer in the tab.

## Windows

This section looks at how you can split nvim working area into windows.

Shortcuts for manipulating windowns in nvim typically start with `CTRL-w`.

**Split (create)** windows:

- **Horizontal**: commands `split`, `sp`. Or `CTRL-w s` shortcut.
- **Vertical**: commands `vsplit`, `vsp`. Or `CTRL-w v` shortcut.
- **Close** the window with `:q` or `CTRL-w q` shortcut.

**Note.** You can pass the filename as an argument to commands `split` and `vsplit`. The correspoinding file will be opened in the new split.

To **switch between splits**, press `Ctrl-w` and then use the standard Vim motion keys (`h`, `j`, `k`, `l`) to move between windows.

Under the hood, `Ctrl-w` invokes Vim’s built-in `:wincmd` dispatcher. The following key (`h`, `j`, `k`, or `l`) is passed as an argument to `:wincmd`, which performs the corresponding window move (left, down, up, or right).

To **close** some of the splits you have options:

- `close` (`CTRL-w + c`) to close current section.
- `only` (`CTRL-w + o`) to leave just current section.

To **change size** of the split use:

- `CTRL-w + "+/-"`: to increase/decrease the size of the current section horizontally.
- `CTRL-w + "</>"`: to increase/decrease the size of the current section vertically.
- **Note** nvim supporst resizing with mouse, in post cases this is the most convenient option.

The commands `CTRL-W H`, `CTRL-W J`, `CTRL-W K`, and `CTRL-W L` move the current window to the far left, bottom, top, or right of the window layout, respectively. They are disabled in my configuration because they ussually exhibit confusing and not revertable behaviour when CapsLock is activated.

Check the [Splitting windows](https://neovim.io/doc/user/usr_08/#usr_08.txt) of the vim manual.

## Tabs

Create tabs that keep other documents and switch between them. Use teh `:tab split` command to reopen the current file in a new tab. To switch between tabs use: 

- The `<C+S+PgUp>`, `<C+S+PgDown>` shortcuts, but these uslually conflict with internal terminal tabs.
- The `<g+t>`, `<g+T>` default nvim combination for switching tabs.
