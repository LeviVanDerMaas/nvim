-- :h nvim-treesitter-modules
-- External plugins are also configured here
require("nvim-treesitter.configs").setup {
  -- (Builtin) Let treesitter handle syntax highlighting
  highlight = { enable = true },

  -- (Builtin) Let treesitter handle indentation (including = operator)
  indent = { enable = true },

  -- (Builtin) Enable incremental selection binds.
  -- TODO: May want to look into nvim-treesitter-textobjects/context
  -- as these seem more convenient and powerful.
  incremental_selection = {
    enable = true
  }
}
