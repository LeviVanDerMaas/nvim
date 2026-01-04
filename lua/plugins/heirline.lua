local conditions = require "heirline.conditions"

-- If an itemgroup does not have a minwid and all items in it are empty, the
-- full group including plaintext evaluates to empty.
local function itemGroup(content, fields)
  fields = fields or {}
  return table.concat {
    fields.ljustify and "-" or "",
    fields.leading_0s and "0" or "",
    fields.minwid and tostring(fields.minwid) or "",
    fields.maxwid and "." or "",
    fields.maxwid and tostring(fields.maxwid) or "",
    content
  }
end

-- Trivials
local AlignSep = { provider = "%=" }
local Filename = { provider = "%<%f %h%w%m%r%=%-14.(%l,%c%V%) %P" }
local GitBranch = {
  condition = conditions.is_git_repo,
  provider = itemGroup
}

local StatusLine = {
  static = {
    mode_color = function(self)
      if g:colors
    end
  }
  Filename,
}

require("heirline").setup {
  statusline = StatusLine
}
