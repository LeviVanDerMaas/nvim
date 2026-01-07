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
    ["\22"] = "V-BLCK",
    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLCK",
    i = "INSERT",
    R = "REPLCE",
    c = "COMMND",
    r = "PROMPT",
    ["!"] = "SHELL!",
    t = "TRMNAL",

    -- Operator pending
    no = "O-PEND",

    -- Ex mode
    cv = "CMD-EX",

    -- Virtual replacement mode
    Rv = "R-VIRT",

    -- i_CTRL-O (i.e.temporary NORMAL mode)
    niI = "I-NORM",
    niR = "R-NORM",
    niV = "R-NORM",
    nt = "T-NORM",

    -- v_CTRL-O (i.e. temporary VISUAL mode)
    vs = "V-SLCT",
    Vs = "V-SLCT",
    ["\22s"] = "V-SLCT",

    -- Completion modes
    ic = "I-CMPL",
    ix = "I-XCMP",
    Rc = "R-CMPL",
    Rx = "R-XCMP",
    Rvc = "RV-CMP",
    Rvx = "RV-XCP",
}
setmetatable(mode_names, { __index = mapLargestPrefix })

-- TODO: Change how this is setup so that it does not depend on catppuccin and
-- also offers means to change with the theme or fallback to defaults.
local c_mocha = require("catppuccin.palettes").get_palette "mocha"
local mode_colors = {
  -- Base modes (single char)
  -- n = c_mocha.blue,
  -- v = c_mocha.mauve,
  -- V = c_mocha.mauve,
  -- ["\22"] = c_mocha.mauve,
  -- s = c_mocha.pink,
  -- S = c_mocha.pink,
  -- ["\19"] = c_mocha.pink,
  -- i = c_mocha.green,
  -- R = c_mocha.red,
  -- c = c_mocha.maroon,
  -- r = c_mocha.maroon,
  -- ["!"] = c_mocha.maroon,
  -- t = c_mocha.sky,


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
  update = "ModeChanged", -- TODO: Look into why the cookbook recommends something more complex?
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
