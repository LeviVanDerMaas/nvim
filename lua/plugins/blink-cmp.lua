require("blink.cmp").setup {
  sources = {
    -- Default sources to enable, can be a function for dynamics.
    default = {
      -- Builtin completion sources.
      "lazydev", "lsp", "snippets", "buffer", "path",
    },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100 -- Makes lazydev completions higher prio
      }
    }
  },

  fuzzy = { implementation = "prefer_rust_with_warning" }
}
