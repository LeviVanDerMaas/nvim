-- NOTE: We could optimize this system by isntead just incrementing a counter
-- tracking the number of modified bufs by 1 each time a previously unmodified
-- buffer becomes modified, and vice versa. Problem is that currently behaviour
-- of events on a change of the modified flag is inconsistent
-- https://github.com/neovim/neovim/issues/37317 so a single rare edge-case can
-- cause desync. The overhead on counting all modified buffers each time is negligible
-- anyway when we only do it on events where the count can actually change unless you
-- have like a 1000 buffers (why would you do this?). If this ever becomes stable though
-- it might be worth considering.
--
-- NOTE: If you ever seem to get more buffers counted as modified then you'd expect, it
-- is likely because some plugin is creating an unlisted modified buffer, or
-- you have an open terminal buffer (currently this is bugged though and does not
-- show up as a modified buffer https://github.com/neovim/neovim/issues/37308)
--
-- NOTE: Currently the BufModifiedSet event is bugged and doesn't trigger until
-- the buffer is redrawn (e.g. when not the current buffer it won't fire till
-- switching back). https://github.com/neovim/neovim/issues/32817
-- A fix is in the works. The only semi-common case in which this would be noticable
-- is when using :wa while the current buffer is unmodified but another is, as that
-- means the counter won't update till switching to that buffer.
--
-- NOTE: Currently the modified flag in terminal-buffers is bugged. They are supposed
-- to be set to true by default, but they are not. Despite this, some parts of neovim,
-- like vim.fn.getbufinfo, still treat them as such: https://github.com/neovim/neovim/issues/37308
--
local update_events = { "BufModifiedSet", "BufAdd", "BufDelete", "BufUnload", "OptionSet" }
local augroup = vim.api.nvim_create_augroup("plugins.heirline", { clear = false })


local function count_bufs_modified()
  local count = 0
  for _, b in pairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_get_option_value("modified", { buf = b }) then
      count = count + 1
    end
  end
  return count
end

local num_bufs_modified = count_bufs_modified()
local function set_bufs_modified(event) num_bufs_modified = count_bufs_modified(); print(vim.inspect(event.event)) end

-- BufModifiedSet does not trigger when the modified option is manually set,
-- so handle seperately. See above notes.
vim.api.nvim_create_autocmd(
  { "BufModifiedSet", "BufAdd", "BufDelete", "BufUnload", "BufWipeOut" }, {
    group = augroup,
    callback = set_bufs_modified
  }
)
vim.api.nvim_create_autocmd({ "OptionSet" }, {
  group = augroup,
  pattern = "modified",
  callback = set_bufs_modified
})

-- A component that shows explictly if the current buffer is modified,
-- as well as shows the total number of modified listed buffers when >1.
return {
  update = { "BufModifiedSet", "BufAdd", "BufDelete", "BufUnload", "BufWipeOut", "OptionSet" },
  provider = function ()
    if num_bufs_modified > 0 then
      return table.concat {
        "[",
         num_bufs_modified > 1 and num_bufs_modified or "",
        -- %M will be empty if the buffer is not modified but is modifiable
         (vim.bo.modified or not vim.bo.modifiable) and "%M" or "*",
        "]"
      }
    end
    return ""
  end
}
