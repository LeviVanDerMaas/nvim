{ pkgs, ... }: with pkgs; with pkgs.vimPlugins; [

  # QUALITY OF LIFE
  catppuccin-nvim # Theme; integrates with many plugins
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
      nvim-web-devicons # Nerd font icons
      # fd is optional dep, but seems to be only used when rg is not available.
    ];
  }

  # TREESITTER
  {
    # The nixpkgs reference manual recommends installing treesitter with
    # `.withPlugins' or `.withAllGrammars` to make treesitter grammars
    # available. However that wraps each grammar as its own individual plugin,
    # which polutes Vim's runtimepath and the produced pack directory quite a
    # bit and also makes parser lookup linear instead of constant.
    # So instead we just symlink all parsers into a single plugin
    plugin = nvim-treesitter;
    dependsOn = [
      (symlinkJoin {
        name = "nvim-treesitter-parsers";
        paths = lib.attrValues nvim-treesitter.grammarPlugins;
      })
    ];
  }

  # LSP
  {
    plugin = nvim-lspconfig; # (Semi-)official LSP configurations for nvim. Does not provide lsps itself.
    dependsOn = [
      # lazydev # Configure LuaLS for editing neovim config
    ];
    extraPackages = [
      lua-language-server
    ];
  }
  blink-cmp # Comprehensive, batteries-included, neovim completion engine
  fidget-nvim # Adds corner-window with LSP (and optionally for other) notifications
  tiny-inline-diagnostic-nvim # Inline diagnostics plugin
]
