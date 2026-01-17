local utils = require("heirline.utils")

-- A table that contains very basic statusline components, as welll as
-- functions that serve as building blocks for other components.
local M = {}

M.Aligner = { provider = "%=" }
M.Space = { provider = " " }
M.Ruler = { provider = "%l:%c" }
M.BufferProgress = { provider = "%P" }

-- Returns a component that's `n` spaces
function M.spaces (n)
  return { provider = string.rep(" ", n) }
end

-- Wraps a copy of `component` in an itemgroup as defined by `:h 'statusline'`.
function M.itemGroup (component, fields, color)
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


--- Returns a component whose children are a deep copy of `components`, with
--- `separator` inserted between each child. A `separator` instance is
--- evaluated only when a preceding child was, and its own `condition` is also
--- respected.
---
--- @param components table[] Components to separate
--- @param separator? table A separator component, defaults to a single space.
--- @param opts? table Options dict:
---  - leading (boolean) optional: Whether to have a separator before the first
---    evaluated component from `components`
---  - trailing (boolean) optional: As above, but after last evaluated component
---  - separator_on_empty (boolean) optional: If true, still evaluate a single
---    separator when none of the components from `components` get evaluated
function M.separate(components, separator, opts)
  separator = separator or require("plugins.heirline.components.basics").Space
  opts = opts or {}

  -- Internal table shared between components, to track evaluations.
  local _shared = {}

  local leading = opts.leading
  local parent = {
    init = function()
      -- If we want a leading separator, then just eval separators from the get-go.
      _shared.eval_prefix_separators = leading
      _shared.child_evaluated = false
    end
  }

  local separator_condition = separator.condition
  local separating_prefix = utils.clone(separator)
  if separator_condition then
    separating_prefix.condition = function()
      return _shared.eval_prefix_separators and separator_condition(separating_prefix)
    end
  else
    separating_prefix.condition = function()
      return _shared.eval_prefix_separators
    end
  end

  -- We prefix each component with an instance of the separator that will only
  -- evaluate if `_shared.eval_separators` is true and if the originally
  -- passed separator's condition passes. Then we "move" the condition of the
  -- component to a parent that contains both the prefix and the component; this
  -- parent then sets `_shared.eval_separators` to true if it gets evaluated.
  for i, c in ipairs(components)  do
    local child = utils.clone(c)
    local child_condition = child.condition
    child.condition = nil
    parent[i] = {
      condition = child_condition,

      separating_prefix,
      {
        init = function ()
          -- Be careful not to set these before evaluating the prefix!
          _shared.eval_prefix_separators = true
          _shared.child_evaluated = true
        end,
        child
      }
    }
  end

  if opts.trailing then
    table.insert(parent, {
      condition = function()
        return _shared.child_evaluated
      end,
      separating_prefix
    })
  end

  if opts.separator_on_empty then
    -- Note that this separator should not use the same logic as the prefix
    -- separators (after all this one is not actually prefixed to another
    -- component), because we actually want to render this only when no other
    -- components are rendered instead of with them
    local separating_empty = utils.clone(separator)
    if separator_condition then
      separating_empty.condition = function()
        return not _shared.child_evaluated and separator_condition()
      end
    else
      separating_empty.condition = function()
        return not _shared.child_evaluated
      end
    end
    table.insert(parent, separating_empty)
  end

  return parent
end

return M
