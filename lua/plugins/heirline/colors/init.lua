local utils = require "heirline.utils"

-- With NONE we fallback to whatever highlights parent components set,
-- or what the colorscheme itself has set (e.g. hi-StatusLine)
-- Can't use an __index metatable because heirline only copies values.
local default_colors = {
  mode_normal = "NONE",
  mode_visual = "NONE",
  mode_select = "NONE",
  mode_insert = "NONE",
  mode_replace = "NONE",
  mode_command = "NONE",
  mode_terminal = "NONE",

  modified_current = "NONE",
  modified_noncurrent = "NONE",

  ruler = "NONE",
}

local function setup_colors()
  local colorscheme =  vim.g.colors_name
  local has_mapping, colorscheme_colors =
    pcall(require, "plugins.heirline.colors.colorscheme_colors." .. colorscheme)
  if has_mapping then
    return vim.tbl_extend("keep", colorscheme_colors, default_colors)
  end
  return default_colors
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("plugins.heirline", { clear = false }),
  callback = function ()
    utils.on_colorscheme(setup_colors)
  end
})

return setup_colors
