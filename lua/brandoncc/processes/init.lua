local vim = vim

if (vim.g.brandoncc_processes_loaded == 1) then
  return
end

vim.g.brandoncc_processes_loaded = 1

M = {}

-- Returns list of pids for a process tree, including the pid of the process
-- itself. Child pids are listed after their parent pid. For example:
--
--                1
--               / \
--              2   5
--             / \   \
--            3   4   6
--
-- returns: [1, 2, 3, 4, 5, 6]
local function tree(parent_pid, branches)
  if not parent_pid then
    error("No parent pid given")
  end

  if not branches then
    branches = { parent_pid }
  end

  local child_pids = vim.api.nvim_get_proc_children(parent_pid)

  for _, pid in ipairs(child_pids) do
    table.insert(branches, pid)
    tree(pid, branches)
  end

  return branches
end

local function is_running(pid)
  -- ps has a header line, so if the line count is 1, no matching pids were
  -- found.
  return vim.fn.str2nr(vim.fn.system("ps " .. pid .. " | wc -l")) > 1
end

-- Wait until a pid is no longer running. If the timeout is reached, then
-- return nil. If the process died successfully, then return true.
local function wait_until_dead_or_timeout(pid, timeout_in_seconds)
  local timeout_in_milliseconds = timeout_in_seconds * 1000
  local start_time = vim.loop.now()

  while true do
    local running = is_running(pid)

    if running == false then
      return true
    end

    if vim.loop.now() - start_time > timeout_in_milliseconds then
      return nil
    end
  end
end

-- Kills a process tree, including the parent process itself. Child pids
-- are killed before their parent pid.
local function kill_tree(parent_pid, opts)
  if not opts then
    opts = {}
  end

  if not opts.timeout then
    opts.timeout = 5
  end

  if not opts.signals then
    opts.signals = { 'TERM', 'KILL' }
  end

  local pids = tree(parent_pid)

  for i = #pids, 1, -1 do
    local pid = pids[i]

    for _, signal in pairs(opts.signals) do
      if opts.log_signals then
        print(vim.fn.printf("Killing %s with signal %s", pid, signal))
      end

      vim.fn.system("kill -" .. signal .. " " .. pid)
      local dead = wait_until_dead_or_timeout(pid, opts.timeout)

      if dead then
        break
      end
    end

    if opts.log_signals then
      print('Done sending signals')
    end
  end
end

M.kill_tree = kill_tree

return M
