-- Set these very early as keymaps expand <leader> upon definition
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require "core.options"
require "core.keymaps"

-- QUALITY OF LIFE
require "plugins.catppuccin"
require "plugins.guess-indent"
require "which-key"

-- GIT INTEGRATION
require "plugins.gitsigns"

-- TELESCOPE
require "plugins.telescope"

-- LSP etc.
