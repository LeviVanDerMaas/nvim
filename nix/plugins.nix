{ pkgs, ... }: with pkgs; with pkgs.vimPlugins; [

  # UI
  catppuccin-nvim # Theme; integrates with many plugins

  # QUALITY OF LIFE
  guess-indent-nvim # Heurstically set local expandtab,tabstop, softtabstop, shiftfwidth
  which-key-nvim # Shows popups with available key bindings on short pause

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

  # LSP etc.
  {
    # (Semi-)official LSP configurations for nvim. Does not provide lsps itself.
    plugin = nvim-lspconfig;
    extraPackages = [];
  }
  tiny-inline-diagnostic-nvim # Inline diagnostics plugin
]
