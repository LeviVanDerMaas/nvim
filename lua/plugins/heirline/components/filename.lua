local FileNameBlock = {
  static = {
    -- Buf types which we do not consider "normal" :h buftype
    special_buftypes = { help = true, ternminal = true }
  },
  init = function (self)
    self.buftype = vim.bo.buftype
  end
}

local NormalFile = {
  condition = function (self) return not self.special_buftypes[self.buftype] end,
  provider = function ()
    -- Shortest relative path when under current dir.
    -- Contrary to %f, this resolves dot dirs.
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":~:.")
  end
}

local HelpFile = {
  condition = function (self) return vim.bo.buftype == "help" end,
  provider = function (self)
    local filename = vim.api.nvim_buf_get_name()
  end
}

return {
  init = function (self)
    self.buftype = vim.bo.buftype
  end,
}
