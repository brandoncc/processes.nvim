processes.nvim
---

This package currently has one function, `kill_tree`.

I chose to namespace it under `brandoncc` because `processes` seems like a name
that might collide with other packages or even something native eventually.

## Usage

```vim
lua require("brandoncc.processes").kill_tree(<pid>, [wait_time_in_seconds])
```

## API

### kill_tree

`kill_tree` accepts a process id (pid), and kills its process tree. The tree is
walked to the bottom and then each level of children is killed before its
parent. The last pid to be killed is the one that is passed in.

A second argument is optional, which is a number representing how many seconds
you are willing to wait for each process to be killed. Processes are initially
sent a `SIGTERM` signal. If the timeout threshold is reached, the process is
sent a `SIGKILL`, which should kill it immediately. The default timeout is five
seconds.

Processes are killed one a time, not in parallel.

## Contributing

I have some ideas how the `kill_tree` function could be improved (allowing the
signals to be specified, in particular). I'm sure I will also eventually add
more functions, when the need arises.

If you have ideas how this package can be improved and extended, please open an
issue so we can discuss them. Ideas are welcome!
