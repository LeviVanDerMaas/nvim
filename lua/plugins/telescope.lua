require("telescope").setup {}

-- Load the native fzf sorter, assumig it is installed
require("telescope").load_extension "fzf"


local km = vim.keymap
local tsb = require "telescope.builtin"


-- File pickers
km.set("n", "<Leader><Leader>", tsb.find_files, { desc = "Search files"})
km.set("n", "<Leader>fd", tsb.find_files, { desc = "[F]in[d] files"})
km.set("n", "<Leader>fg", tsb.git_files, { desc = "[F]ind [g]it files"})
km.set("n", "<Leader>rg", tsb.live_grep, { desc = "Find by [r]ip[g]rep"})
km.set("n", "<Leader>rs", tsb.grep_string, { desc = "[R]ipgrep [s]tring/[s]election"})

-- Vim pickers
km.set("n", "<Leader>sr", tsb.resume, { desc = "[S]earch [r]esume"})
km.set("n", "<Leader>b", tsb.buffers, { desc = "List open [b]uffers"})
km.set("n", "<Leader>\"", tsb.registers, { desc = "List registers"})
km.set("n", "<Leader>jl", tsb.jumplist, { desc = "[J]ump[l]ist"})
km.set("n", "<Leader>mr", tsb.marks, { desc = "[M]a[r]ks"})
km.set("n", "<Leader>/", tsb.current_buffer_fuzzy_find, { desc = "Fuzzy find in buffer"})
km.set("n", "<Leader>sh", tsb.search_history, { desc = "List [s]earch [h]istory"})
km.set("n", "<Leader>ch", tsb.command_history, { desc = "List [c]ommand [h]istory"})
km.set("c", "<C-h>", tsb.command_history, { desc = "List [c]ommand [h]istory"})


-- TODO: look into:
-- Making the command_history maps insert the command on <CR> instead of executing it, currently this is done with <C-e>
-- Git pickers, especially the history ones
-- Lsp pickers
