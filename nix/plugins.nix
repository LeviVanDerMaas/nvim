{ pkgs, ... }: with pkgs; with pkgs.vimPlugins; [

  # QUALITY OF LIFE
  catppuccin-nvim # Theme; integrates with many plugins
  lualine-nvim
  heirline-nvim # Statusline utility API for generating format strings.
  guess-indent-nvim # Heurstically set local expandtab, tabstop, softtabstop, shiftfwidth
  which-key-nvim # Shows popups with available key bindings on short pause
  nvim-surround # Operator-based insertion and manipulation of pairs like (), "", etc.
  rainbow-delimiters-nvim # Adds rainbow coloring to pair-based delimiters.
  indent-blankline-nvim # Adds indentation guides, integrates with rainbow-delimiters

  # GIT INTEGRATION
  vim-fugitive # Git interface for Vim (repo-level)
  gitsigns-nvim # Deep buffer-level integration for Git

  # TELESCOPE
  {
    plugin = telescope-nvim;
    dependsOn = [
      plenary-nvim # Required dep
      telescope-fzf-native-nvim # Recommended for better sorting performance
    ];
    extraPackages = [
      ripgrep # Recommended, and required for grep pickers
      # nvim-web-devicons # Nerd font icons
      # fd is optional dep, but seems to be only used when rg is not available.
    ];
  }

  # TREESITTER
  # In the past, this package installed all grammars as seperate plugins,
  # although more recently it seems to actually properly put them all under
  # one `parser` dir (as a single plugin); keep an eye on it though.
  nvim-treesitter.withAllGrammars

  # LSP
  {
    plugin = nvim-lspconfig; # (Semi-)official LSP configurations for nvim. Does not provide lsps itself.
    dependsOn = [
      lazydev-nvim # Configure LuaLS for editing neovim config
    ];
    extraPackages = [
      lua-language-server
      clang-tools # clangd
    ];
  }
  blink-cmp # Comprehensive, batteries-included, neovim completion engine
  fidget-nvim # Adds corner-window with LSP (and optionally for other) notifications
  tiny-inline-diagnostic-nvim # Very neat inline diagnostics plugin
]
