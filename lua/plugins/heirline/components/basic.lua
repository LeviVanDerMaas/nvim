local utils = require("heirline.utils")

-- A table with basic, reusuable components for use with other components.
return {
  Aligner = { provider = "%=" },
  Space = { provider = " " },

  -- Wraps component in an itemgroup as defined by `:h 'statusline'`.
  itemGroup = function (component, fields, color)
    fields = fields or {}
    local delimiters = {
      table.concat {
        "%",
        fields.ljustify and "-" or "",
        fields.l0s and "0" or "",
        fields.minwid and fields.minwid or "",
        fields.maxwid and "." or "",
        fields.maxwid and fields.maxwid or "",
        "("
      },
      "%)"
    }
    return utils.surround(delimiters, color, component)
  end
}
