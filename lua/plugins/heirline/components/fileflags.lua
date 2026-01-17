local M = {}

local buftypeStrings = {
  acwrite = "[BufWriteCmds]",
  help = "[Help]",
  nofile = "[NoFile]",
  nowrite = "[NoWrite]",
  terminal = "[Terminal]",
  prompt = "[Prompt]",
  quickfix = "%q",
}

M.Modifiable = {
  condition = function()
    return not vim.bo.modifiable or vim.bo.readonly
  end,
  provider = function()
    -- The no-modifiable flag is  "stronger" than the RO flag
    if not vim.bo.modifiable then
      return "[-]"
    end
    return "[RO]"
  end
}

M.Preview = {
  condition = function()
    return vim.wo.previewwindow
  end,
  provider = "[Preview]"
}

M.Buftype = {
  condition = function()
    return vim.bo.buftype ~= ""
  end,
  provider = function()
    return buftypeStrings[vim.bo.buftype]
  end
}

return M
