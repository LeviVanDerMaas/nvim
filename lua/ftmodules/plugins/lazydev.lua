-- TODO: setup exrc
require("lazydev").setup {
  library = { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  enabled = function(root_dir)
    vim.notify("Pls fix lazydev loading", vim.log.levels.WARN)
    return true
  end
}
