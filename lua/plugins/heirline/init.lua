local basic = require "plugins.heirline.components.basic"

local Mode = require "plugins.heirline.components.mode"
local Filepath = { provider = "%f" }
local BufsModified = require "plugins.heirline.components.bufs_modified"

local StatusLine = {
  basic.Space,
  basic.itemGroup(Mode, { minwid = 8, ljustify = true }),
  basic.Space,
  basic.itemGroup(BufsModified, { minwid = 4 } ),
  basic.Space,
  Filepath
}

require("heirline").setup {
  opts = {},
  statusline = StatusLine,
  colors = require "plugins.heirline.colors",
}

-- Note that Heirline won't trigger a statusline redraw by itself (unless you explictly program a component
-- to do so), e.g. if you're in COMMAND mode component updates won't actually be visible on the statusline
-- until you leave COMMAND mode or explictly call :redrawstatus.
-- Checking the source code of heirline, update works as follows:
-- If update is set, a cache will be checked: if that cache is not nil, then the cache is used;
-- otherwise the rest of the component is evaluated.
--   # If update is a function, cache will be set to nil when function returns true
--   # If update is autocmds, these autocmds will set the cache to nil when triggered
--   # If update is nil, no cache checking is done and full component is evaluated.
-- Once done updating all statusline components, all components with update not nil will have cache set.
--
-- NOTE: If you get any erros from statusline on leaving use this:
--:au VimLeavePre * set stl=
