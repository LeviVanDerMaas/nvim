local lib = require "plugins.heirline.lib"
local conditions = require "heirline.conditions"

local Mode = require "plugins.heirline.mode"
local Filepath = { provider = "%f" }
local BufsModified = require "plugins.heirline.bufs_modified"

require("heirline").setup {
   ---@diagnostic disable-next-line: missing-fields
  statusline = {
    lib.Space,
    Mode,
    lib.Space,
    lib.itemGroup(BufsModified, { minwid = 5 } ),
    lib.Space,
    Filepath
  }
}
