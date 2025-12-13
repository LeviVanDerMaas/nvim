-- Set these very early as keymaps expand <leader> upon definition
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require "core.options"
require "core.keymaps"

require "plugins.catppuccin"
