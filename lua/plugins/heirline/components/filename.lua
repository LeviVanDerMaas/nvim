local utils = require "heirline.utils"
local conditions = require "heirline.conditions"

local FileNameBlock = {
  static = {
    special_buftypes = { help = true, terminal = true }
  },
}

local NormalFile = {
  condition = function (self) return not self.special_buftypes[vim.bo.buftype] end,
  provider = function ()
    -- Shortest relative path when under current dir.
    -- Contrary to %f, this simplifies filenames.
    local filename = vim.api.nvim_buf_get_name(0)
    if filename == "" then return "[No Name]" end
    return vim.fn.fnamemodify(filename, ":.")
  end
}

local HelpFile = {
  condition = function () return vim.bo.buftype == "help" end,
  provider = function ()
    local filename = vim.api.nvim_buf_get_name(0)
    return vim.fn.fnamemodify(filename, ":t")
   end
}

local TerminalFile = {
  condition = function () return vim.bo.buftype == "terminal" end,
  provider = function ()
    return vim.b.term_title
   end
}

return utils.insert(FileNameBlock, {
  NormalFile,
  HelpFile,
  TerminalFile
})
