require("blink.cmp").setup {
  sources = {
    -- Default sources to enable, can be a function for dynamics.
    default = {
      -- Builtin completion sources.
      "lsp", "snippets", "buffer", "path",
    }
  },

  fuzzy = { implementation = "prefer_rust_with_warning" }
}
