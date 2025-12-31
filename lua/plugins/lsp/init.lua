-- LSPs themselves must be provided externally, this dir is just to configure
-- and enable them. :h lsp-config for more info.

-- Call vim.lsp.enable to let LSPs auto attach to new buffers as configged.
-- Call AFTER setting any LSP-specific config.
-- vim.lsp.config("*", {}) -- Base config overriden even by lsp/<config.lua>
local enabled_lsps = { "lua_ls" }
for _, v in ipairs(enabled_lsps) do
  pcall(require, "plugins.lsp." .. v)
  vim.lsp.enable(v)
end

-- Config to run whenever an lsp attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("plugin.lsp", { clear = true }),
  callback = function (event)
    local tsb = require "telescope.builtin"
    local lsp_km = function (keys, func, desc, mode)
      vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- Setup buffer keymaps
    lsp_km("gd", tsb.lsp_definitions, "[G]oto reference [d]efintion")
    lsp_km("gD", vim.lsp.buf.declaration, "[G]oto reference [d]eclaration")
    lsp_km("gri", tsb.lsp_implementations, "[G]oto [r]eference [i]mplementations")
    lsp_km("grr", tsb.lsp_references, "[G]oto [r]efe[r]ences")
    lsp_km("grc", tsb.lsp_incoming_calls, "[G]oto [r]eference [c]allers")
    lsp_km("grC", tsb.lsp_outgoing_calls, "[G]oto [r]eference-[c]alled")
    lsp_km("grt", tsb.lsp_type_definitions, "[G]oto [r]eference [t]ype")
    lsp_km("gO", tsb.lsp_document_symbols, "[G]oto d[o]cument symbols")
    -- Compared to lsp_workspace_symbols, this one is non-blocking and updates query dynamically
    lsp_km("g<C-O>", tsb.lsp_dynamic_workspace_symbols, "[G]oto [w]orkspace symbols")
    lsp_km("grn", vim.lsp.buf.rename, "[G]lobally [r]e[n]ame")
    lsp_km("gra", vim.lsp.buf.code_action, "[G]et/[r]un code [a]ctions")
  end
})
