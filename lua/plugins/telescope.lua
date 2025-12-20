require("telescope").setup {}

-- Load the native fzf sorter, assumig it is installed
require("telescope").load_extension "fzf"


local km = vim.keymap
local tsb = require "telescope.builtin"

-- File pickers
km.set("n", "<Leader><Leader>", tsb.find_files, { desc = "Search files" })
km.set("n", "<Leader>fd", tsb.find_files, { desc = "[F]in[d] files" })
km.set("n", "<Leader>fg", tsb.git_files, { desc = "[F]ind [g]it files" })
km.set("n", "<Leader>rg", tsb.live_grep, { desc = "Find by [r]ip[g]rep" })
km.set({"n", "v"}, "<Leader>rs", tsb.grep_string, { desc = "[R]ipgrep [s]tring/[s]election" })
  
-- Vim pickers
km.set("n", "<Leader>sr", tsb.resume, { desc = "[S]earch [r]esume" })
km.set("n", "<Leader>b", tsb.buffers, { desc = "List open [b]uffers" })
km.set("n", "<Leader>'", tsb.marks, { desc = "List [M]a[r]ks" })
km.set("n", '<Leader>"', tsb.registers, { desc = "List registers" })
km.set("n", "<Leader>jl", tsb.jumplist, { desc = "Show [J]ump[l]ist" })
km.set("n", "<Leader>/", tsb.current_buffer_fuzzy_find, { desc = "Fuzzy find in buffer" })
km.set("n", "<Leader>sh", tsb.search_history, { desc = "List [s]earch [h]istory" })
km.set("n", "<Leader>ch", tsb.command_history, { desc = "List [c]ommand [h]istory" })
km.set("c", "<C-h>", tsb.command_history, { desc = "List [c]ommand [h]istory" })

-- Quickfix pickers
km.set("n", "<Leader>q", function() tsb.diagnostics { bufnr = 0 } end, { desc = "Open buffer diagnostic [q]uickfix list" })
km.set("n", "<Leader>Q", function() tsb.diagnostics { sort_by = "severity" } end, { desc = "Open workspace diagnostic [q]uickfix list" })
km.set("n", "<C-q>", vim.diagnostic.setloclist, { desc = "Open buffer diagnostic [q]uickfix window" })
km.set("n", "<M-q>", vim.diagnostic.setqflist, { desc = "Open workspace diagnostic [q]uickfix window" })
km.set("n", "<Leader>l", tsb.loclist, { desc = "Show [l]ocal list" })
km.set("n", "<Leader><C-q>", tsb.quickfix, { desc = "Show [q]uickfix list" })
km.set("n", "<Leader><M-q>", tsb.quickfixhistory, { desc = "Show [q]uickfix list history" })

-- Git pickers
km.set("n", "<Leader>gc", tsb.git_commits, { desc = "List [g]it [c]ommits" })
km.set("n", "<Leader>gb", tsb.git_bcommits, { desc = "List [g]it [b]uffer commits" })
km.set("v", "<Leader>gb", tsb.git_bcommits_range, { desc = "List range's git commits" })
km.set("n", "<Leader>gB", tsb.git_branches, { desc = "List [g]it [b]ranches" })
km.set("n", "<Leader>gs", tsb.git_status, { desc = "List [g]it [s]tatus" })
km.set("n", "<Leader>gS", tsb.git_stash, { desc = "List [g]it [s]tash" })

return {
  -- LSP pickers
  on_lsp_attach = function()
    km.set("n", "gd", tsb.lsp_definitions, { desc = "[G]oto reference [d]efintion" })
    km.set("n", "gD", vim.lsp.buf.declaraton, { desc = "[G]oto reference [d]eclaration" })
    km.set("n", "gri", tsb.lsp_implementations, { desc = "[G]oto [r]eference [i]mplementations" })
    km.set("n", "grr", tsb.lsp_references, { desc = "[G]oto [r]efe[r]ences" })
    km.set("n", "grc", tsb.lsp_incoming_calls, { desc = "[G]oto [r]eference [c]allers" })
    km.set("n", "grC", tsb.lsp_outgoing_calls, { desc = "[G]oto [r]eference-[c]alled" })
    km.set("n", "grt", tsb.lsp_type_definitions, { desc = "[G]oto [r]eference [t]ype" })
    km.set("n", "gO", tsb.lsp_document_symbols, { desc = "[G]oto d[o]cument symbols" })
    -- Compared to lsp_workspace_symbols, this one is non-blocking and updates query dynamically
    km.set("n", "g<C-O>", tsb.lsp_dyamic_workspace_symbols, { desc = "[G]oto [w]orkspace symbols" })

    km.set("n", "grn", vim.lsp.buf.rename, { desc = "[G]lobally [r]e[n]ame" })
    km.set("n", "gra", vim.lsp.buf.code_action, { desc = "[G]et/[r]un code [a]ctions" })
  end
}
