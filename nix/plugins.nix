{ pkgs, ... }: with pkgs; with pkgs.vimPlugins; [

  # UI
  catppuccin-nvim # Theme; integrates with many plugins

  # Telescope
  { plugin = telescope-nvim; dependsOn = [ plenary-nvim ]; }
]
