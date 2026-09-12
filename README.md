# fish_todo

> [WIP](https://en.wikipedia.org/wiki/Work_in_process)

[Todo](https://en.wikipedia.org/wiki/Time_management) in [Fish](https://fishshell.com/) shell

## Description

Simple [Fish](https://fishshell.com/) [Todo](https://en.wikipedia.org/wiki/Time_management) feature.

Can:

- `add` (`a` is an alias) a task
- `clear` (`nukeall` is an alias) all tasks
- `copy` a specific task in memory (useful for sharing purpose)
- `delete` (`del` and `nuke` are alias) a specific task (every task is printed with a relative number and it is enough to pass the specific number as an argument)
- `edit` opens the `todo` file in `$EDITOR` (`$EDITOR` must be set)

Offers the possibility to set a due date for the tasks (minutes, hours, days, weeks, months, years, lustres, decades, centuries).

Every `20` shell commands it prints a kind reminder.

Terminal: [kitty](https://sw.kovidgoyal.net/kitty/)

## Installation

With [Fisher](https://github.com/jorgebucaran/fisher):

```sh
$ fisher install maxdevjs/fish_todo
```

## Usage

```sh
$ todo                                # task list
$ todo [a/add] task                   # add a task
$ todo [clear/nukeall]                # delete all tasks
$ todo copy                           # copy a specific task to memory
$ todo [del/delete/nuke] task_number  # delete a specific task
$ todo edit                           # open task file in `$EDITOR`

```

## TODO

This is a ~~first~~ ~~second~~ third iteration.

- [x] add `edit` feature (`$EDITOR` must be set)
- [x] add `nuke` as `del` alias
- [x] add `nukeall` as `clear` alias
- [x] center output
- [x] add line numbers to facilitate `del` operation
- [x] add timestamp, e.g.: `(added 2026-09-11 05:13:12)`
- [x] add due date, e.g.: `(due 2026-10-09 05:29)`
- [x] add lustres as due date, e.g. 1 lustre: (due 2031-09-11 05:50:34)
- [x] add decades as due date, e.g. 3 decades: (due 2056-09-11 05:50:34)
- [x] add centuries as due date, e.g.: 3 centuries (due 2326-09-11 05:50:34)
- [x] Available units: (minutes, hours, days, weeks, months, years, lustres, decades, centuries)
- [x] add delete range, e.g.: `todo del 3 7`
- [x] refactor `copy` to (hopefully) work in `X11` and `Wayland`
- [ ] fix `del` output with no arguments
- [x] add copyall (tasks)?
- [ ] option to set the `todo` file
  - [ ] name
  - [ ] path
- [ ] add a warning message if too many tasks are pending
- [ ] add completed status (maybe)
- [ ] ...
- [ ] screenshots or: later. Maybe.

Going to check and "borrow" 🏴‍☠️ ideas from

- [ ] [thebitstick/fish-todotxt](https://github.com/thebitstick/fish-todotxt)
  - [ ] oh, wait... it does not have a `copy` feature
    - [ ] not even a `clear/nuke` one 😌
      - [ ] but it has `sort` and `complete` mmmh
        - [ ] definitely, to be checked
