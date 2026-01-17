local basics = require "plugins.heirline.components.basics"
local FileName = require "plugins.heirline.components.filename"
local Mode = require "plugins.heirline.components.mode"
local BufsModified = require "plugins.heirline.components.bufs_modified"
local testx = { provider = "x", condition = function() return DOX end }
local testy = { provider = "y", condition = function() return DOY end }
local testz = { provider = "z", condition = function() return DOZ end }
DOX = false
DOY = false
DOZ = false
local StatusLine = {
  basics.Space,
  basics.itemGroup(Mode, { minwid = 8, ljustify = true }),
  basics.Space,
  basics.Ruler,
  basics.Space,
  basics.itemGroup(BufsModified, { minwid = 4 } ),
  basics.Space,
  FileName,

  basics.Aligner,
  basics.separate({
    testx,
    testy,
    testz
  }, { provider = "_" }),

  basics.Aligner,
  basics.separate({
    testx,
    testy,
    testz
  }, { provider = "_" }, { leading = true }),

  basics.Aligner,
  basics.separate({
    testx,
    testy,
    testz
  }, { provider = "_" }, { trailing = true }),

  basics.Aligner,
  basics.separate({
    testx,
    testy,
    testz
  }, { provider = "_" }, { trailing = true, leading = true }),

  basics.Aligner,
  basics.separate({
    testx,
    testy,
    testz
  }, { provider = "_" }, { separator_on_empty = true }),

  basics.Aligner,
  basics.separate({
    testx,
    testy,
    testz
  }, { provider = "_" }, { leading = true, trailing = true, separator_on_empty = true }),

  basics.Aligner,
  basics.Ruler,
  basics.BufferProgress
}

require("heirline").setup {
  opts = {},
  statusline = StatusLine,
  colors = require "plugins.heirline.colors",
}

-- NOTE: There is only one heirline instance that is shared by multiple statuslines: all vim statuslines
-- call the same eval function and that eval function does not seperate different statuslines. This means
-- that if you use any buffer-local values in your statusline provider, they will carry over to other
-- buffers until the statusline is updated again (in other words be careful with a component's 'update'
-- property when the provider uses buffer-local values).
-- NOTE: Heirline values are "inherited" downwards, but writing does not go back up to the parent.
-- NOTE: If update is set, a cache will be checked: if that cache is not nil, then the cache is used;
-- otherwise the rest of the component is evaluated.
--   # If update is a function, cache will be set to nil when function returns true
--   # If update is autocmds, these autocmds will set the cache to nil when triggered
--   # If update is nil, no cache checking is done and full component is evaluated.
-- Once done updating all statusline components, all components with update not nil will have cache set.
-- NOTE: Heirline won't trigger a statusline redraw by itself (unless you explictly program a component
-- to do so), e.g. if you're in COMMAND mode component updates won't actually be visible on the statusline
-- until you leave COMMAND mode or explictly call :redrawstatus.
-- Checking the source code of heirline, update works as follows:
-- NOTE: If you get any erros from statusline on leaving use this:
--    :au VimLeavePre * set stl=
