-- A component that shows explictly if the current buffer is modified,
-- as well as shows the total number of modified listed buffers when >1.
return {
  static = {
    getbufinfoArgs = { bufmodified = 1, buflisted = 1, bufloaded = 1 }
  },
  -- NOTE: Currently the BufModifiedSet event is bugged and doesn't trigger until
  -- the buffer is redrawn (e.g. when not the current buffer it won't fire till
  -- switching back). https://github.com/neovim/neovim/issues/32817
  -- A fix is in the works. The only semi-common case in which this would be noticable
  -- is when using :wa while the current buffer is unmodified but another is, as that
  -- means the counter won't update till switching to that buffer.
  update = { "BufModifiedSet", "BufAdd", "BufDelete" },
  init = function(self)
    self.num_changed_bufs = #vim.fn.getbufinfo(self.getbufinfoArgs)
  end,
  provider = function (self)
    if self.num_changed_bufs > 0 then
      return table.concat {
        "[",
         self.num_changed_bufs > 1 and self.num_changed_bufs or "",
        -- %M will be empty if the buffer is not modified but is modifiable
         (vim.bo.modified or not vim.bo.modifiable) and "%M" or "*",
        "]"
      }
    end
    return ""
  end
}
