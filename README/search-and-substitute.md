# Search and substitute

To **search** in vim just type `/<symbols combo to search>`. As you type, it will move you to the first occurrence below the cursor. It will also highlight all other instances of the search pattern. After pressing `Enter`, the cursor will move to the closest match below. You can move to the next match by pressing `n` and to the previous match by pressing `N`.

Check the [search](https://neovim.io/doc/user/usr_03/#03.8) section of the vim tutorial.

To specify in search that you need to look only **complete words** not wrapped by other next use `\<` and `\>` symbols.

The idea is represented in the following example:

```
anthem
for them  <- /\<the
now the <- /\<the\>
```

The pattern specified after the `<-` symbol means that that search command will refer to the corresponding line.

To enter to the search mode for the selected text in the visual mode, press `*` (`<Shirt-8>` key).

## Substitute

To **replace** values in vim, you have to use a command like:

```
:[range]substitute/<value to be replaced>/<value to replace>/[flags]
```

The `substitute` command by default have `s` as alias.

The most usefull command are represented in the following table:

| Command                         | Description                                                   |
|--------------------------------|---------------------------------------------------------------|
| `:s/foo/bar/`                  | Replace first occurrence of `foo` with `bar` on the current line |
| `:s/foo/bar/g`                | Replace **all** occurrences of `foo` with `bar` on the current line |
| `:%s/foo/bar/`                | Replace first occurrence of `foo` with `bar` in **all lines**     |
| `:%s/foo/bar/g`              | Replace all occurrences of `foo` with `bar` in the whole file  |
| `:%s/foo/bar/gc`             | Same as above, but **ask for confirmation** before each change |
| `:n,m s/foo/bar/g`           | Replace `foo` with `bar` between lines `n` and `m`             |
| `:'<,'> s/foo/bar/g`         | Replace `foo` with `bar` in the selected in visual mode section. VSCode automatically adds `'<,'>` to the command line when you type `:` in visual mode. |
| `:%s/\<foo\>/bar/g`          | Replace whole word `foo` with `bar` globally                   |
| `:%s/foo/bar/gI`             | Replace `foo` with `bar` globally, **case-insensitive**         |
| `:%s/foo\c/bar/g`            | Also case-insensitive (with `\c` in pattern)                   |
| `:%s/\Vfoo/bar/g`            | Use **very magic** mode (fewer escapes needed in pattern)      |

Use backslash symbol to escape a symbol in a pattern. For example, to replace the pattern `/test` with `hello`, use the command:

```
:s/\/test/hello/
```

To escape a backslash itlself, use the `\\` combination before it. So, to replace the pattern `\$` with `$`:

```
:s/\\\$/$/
```

**Note**: the characters `.*[]^%/\?~$` have a special meaning, so all they have to be escaped in commands and searches.

There are following usefull flags:

- `g`: to apply the substitution globally. By default, it replaces only the first occurance.
- `c`: to ask the confirmation for substitutions.

Check the official description in the [Substitution](https://neovim.io/doc/user/usr_10/#10.2) section of the official documentation.
