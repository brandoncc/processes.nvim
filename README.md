processes.nvim
---

This package currently has one function, `kill_tree`.

I chose to namespace it under `brandoncc` because `processes` seems like a name
that might collide with other packages or even something native eventually.

## Installation

Install using your favorite plugin manager. For example in vim-plug:

```vim
Plug 'brandoncc/processes.nvim'
```

## Usage

```vim
lua require("brandoncc.processes").kill_tree(<pid>, [wait_time_in_seconds])
```

## API

### kill_tree

#### Usage

The first argument is a pid that you would like to kill, along with any
children/grandchildren/etc.

The second argument is the options hash which can have the following structure:

- timeout: number
- signals: a list of kill signals to send, after the process exits, no more
           signals will be sent to that process
- log_signals: a boolean stating whether you would like to see messages echoed
                each time a signal is sent to a process.


The options table can be omitted if you would like to use the defaults.

```lua
require("processes").killtree(pid, {
  timeout = 5,                  -- default value
  signals = { 'TERM', 'KILL' }, -- default value
  log_signals: false,           -- default value
})
```

Processes are killed one a time, not in parallel.

## Contributing

I have some ideas how the `kill_tree` function could be improved (allowing the
signals to be specified, in particular). I'm sure I will also eventually add
more functions, when the need arises.

If you have ideas how this package can be improved and extended, please open an
issue so we can discuss them. Ideas are welcome!
