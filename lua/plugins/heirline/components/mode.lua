local function mapLargestPrefix (t, k)
  for i = #k - 1, 1, -1 do
    local prefix = k:sub(1, i)
    local value = rawget(t, prefix)
    if value then
      return value
    end
  end
  return nil
end

-- Maps values returned by `vim.fn.mode()` to a name. More specific modes
-- (longer strings) fallback to more generic ones (prefix that is defined).
-- `:help mode()` for more info.
local mode_names = {
    -- Base modes (single-char).
    n = "NORMAL",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",
    i = "INSERT",
    R = "REPLACE",
    c = "COMMAND",
    r = "PROMPT",
    ["!"] = "SHELL",
    t = "TERMINAL",

    -- Operator pending
    no = "OPENDING",

    -- Ex mode
    cv = "EX",

    -- Virtual replacement mode
    Rv = "R-VIRT",

    -- i_CTRL-O (i.e.temporary NORMAL mode)
    niI = "I-NORMAL",
    niR = "R-NORMAL",
    niV = "R-NORMAL",
    nt = "T-NORMAL",

    -- v_CTRL-O (i.e. temporary VISUAL mode)
    vs = "V-SELECT",
    Vs = "V-SELECT",
    ["\22s"] = "V-SELECT",

    -- Completion modes
    ic = "I-COMPL",
    ix = "I-XCOMPL",
    Rc = "R-COMPL",
    Rx = "R-XCOMPL",
    Rvc = "R-COMPL",
    Rvx = "R-XCOMPL",
}
setmetatable(mode_names, { __index = mapLargestPrefix })

local mode_colors = {
  n = "mode_normal",
  v = "mode_visual",
  V = "mode_visual",
  ["\22"] = "mode_visual",
  s = "mode_select",
  S = "mode_select",
  ["\19"] = "mode_select",
  i = "mode_insert",
  R = "mode_replace",
  c = "mode_command",
  r = "mode_command",
  ["!"] = "mode_command",
  t = "mode_terminal",
}
setmetatable(mode_colors, { __index = mapLargestPrefix })

return {
  condition = require("heirline.conditions").is_active,
  update = {
    "ModeChanged",
    -- Explicitly schedule redraw because O-PENDING does not trigger redraw by itself
    -- Also some plugins may cause textlock for other modes (e.g. which-key for Visual-L/B).
    callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
  },
  init = function(self)
    self.mode = vim.fn.mode(1)
  end,
  provider = function(self)
    return mode_names[self.mode]
  end,
  hl = function (self)
    return { fg = mode_colors[self.mode], bold = true }
  end
}
