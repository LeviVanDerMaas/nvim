-- Lsps themselves must be provided externally.
-- Nvim configures lsps through calls to vim.lsp.config(),
-- then tables found in lsp/<config>.lua on the runtimepath (merge-based).
-- nvim-lspconfig provides a bunch of the latter, which vim.lsp.config overrides

-- Default settings for on_attach
local function default_on_attach()

end
