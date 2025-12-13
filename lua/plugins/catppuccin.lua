-- Theme has a lot of config settings, check 'em on gh:
-- https://github.com/catppuccin/nvim If you want to change something about ui
-- colors, chances are you can do it more easily and consistenly with this
-- setup function instead. Also has plenty of integrations for other plugins
require("catppuccin").setup {
  flavour = "auto",
  background = {
    light = "latte",
    dark = "mocha",
  },
  float = {
    transparent = true,
  },
}

vim.cmd.colorscheme "catppuccin"
