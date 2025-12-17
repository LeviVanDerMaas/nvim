{ pkgs, ... }: with pkgs; with pkgs.vimPlugins; [

  # UI
  catppuccin-nvim # Theme; integrates with many plugins

  # Telescope
  { 
    plugin = telescope-nvim;
    dependsOn = [
      plenary-nvim # Required dep
      telescope-fzf-native-nvim # Recommended for better sorting performance
    ];
    extraPackages = [ 
      ripgrep # Recommended, and required for grep pickers
      deviccons # Nerd font icons
      # fd is optional dep, but seems to be only used when rg is not available.
    ];
  }
]
