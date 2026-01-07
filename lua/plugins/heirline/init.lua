local basic = require "plugins.heirline.components.basic"

local Mode = require "plugins.heirline.components.mode"
local Filepath = { provider = "%f" }
local BufsModified = require "plugins.heirline.components.bufs_modified"

local StatusLine = {
  basic.Space,
  Mode,
  basic.Space,
  basic.itemGroup(BufsModified, { minwid = 5 } ),
  basic.Space,
  Filepath
}

require("heirline").setup {
  opts = {},
  statusline = StatusLine,
  colors = require "plugins.heirline.colors"
}

-- Checking the source code, update works as follows on each statusline redraw:
-- If update is set, a cache will be checked: if that cache is not nil, then the cache is used;
-- otherwise the rest of the component is evaluated.
--   # If update is a function, cache will be set to nil when function returns true
--   # If update is autocmds, these autocmds will set the cache to nil when triggered
--   # If update is nil, no cache checking is done and full component is evaluated.
-- Once done updating all statusline components, all components with update not nil will have cache set.
