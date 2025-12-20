-- vim.loader.enable() -- Enables module caching between sessions. Call ASAP.

-- Set these very early as keymaps expand <leader> upon definition
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require "core.options"
require "core.keymaps"

-- QUALITY OF LIFE
require "plugins.catppuccin"
require "plugins.guess-indent"
require "plugins.which-key"
require "plugins.nvim-surround"
require "plugins.indent-blankline"

-- GIT INTEGRATION
require "plugins.gitsigns"

-- TELESCOPE
require "plugins.telescope"

-- TREESITTER

-- LSP
require "plugins.fidget"
