# Vim motions

Vim's true power is its special text navigation system. Many popular code/text editors support extentions that emulate the Vim behaviour. While most are really obvious, some are more subtle and easy to overlook, os this section explores usefull tricks associated with using the Vim navigation system:

- **Paired brackets**: keep the cursor in the normal mode in the bracked the `%` (`<C-5>`) moves the cursor to the paired bracked.
- **Repeating insert**: If you type the number before entering the insert mode, when you return to the normal mode, the text you're inserting will be repeated the specified number of times. It's a typical thing for me to do occasionally, but the usful case `80i=<ESC>` allows you to put 80 `=` in a row, which is usefull for building visual separators in the plain text.
- **Exit file**: use `ZZ` (`shift + z, shift + z`) to save the file and automatically close it.
- **Moving to a character**: with the `f` command, you can jump to the specified symbol on the current line. This is not really useful with regular text symbols, but programming and formal languages typically have some kind of special symbols. For example, jump from the begining to the end of the cycle definition in the line `for i in range(10): print(i)`, use `f:`.
    - To go to symbol backwards use capital `F`.
    - To go to the symbol that previous before the specified symbol use `t` and `T` respectively.
- **Goto line**.
    - Type number of the line + enter.
    - Type `<number%> + <CR>`  to go to the specified procent of the lines.
    - `gg` to the first line and `G` to the last.
- **Relatively to screen** if you need to scroll past the visible area, there is an option to scroll relative to the number of lines visible in the working area:
    - `<PgUp>`, `<PgDown>` to scroll one screen.
    - `<C-d>`, `<C-u>` to scroll half of the screen **d**own and **u**p respectively.
- **Scrooll** if you need to scrooll the visible text without changing the possition of the cursor:
    - `<C-y>`/`<C-e>` to scroll one line up/down.

Check the [chapter 2](https://neovim.io/doc/user/usr_02/#usr_02.txt) and [chapter3](https://neovim.io/doc/user/usr_03/#usr_03.txt) of the vim quick start to learn more about basic motions features.

## Jumps

Jumps are a movements between different part of a text, according to a certain rules.

The jumps could be:

- Move to line `:<number of the line>`.
- Different lsp related movements: `grt`, `grr` and so on.
- When search brings you to some line.

Check the list of your jumps with the command `:jumps`.

You can go to the previous jump by `<C-o>`, or to the next one by pressing `<C-i>`.

## Macros

You can record the actions you did and apply in some other place.

The following keys are responsble for building macroses:

- Start recording a macro with `q{register}`. The `{register}` is a letter which is used to name this macro.
- Finish recording with `q`.
- Apply the macro with `@{register}` and vim will perform the same actions that you performed during the recording.

**Note** that the registers are the same for yanking and macros. Macros are simply recorded into the regular register as a plain text. You can therefore pasate macros and return them to the register.

You can add the commands to the existing macros by invoking the recording for capital register. For example to append actions to the register `a` use `qA` command.

Check more in the [Record and playback commands](https://neovim.io/doc/user/usr_10/#10.1) section of the user manual.
