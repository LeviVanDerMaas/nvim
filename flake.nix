{
  description = "Basic flake with Nix shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: let
    arch = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${arch};
    lib = nixpkgs.lib;
  in {
    devShells.${arch}.default = pkgs.mkShell {
      name = "nvim-config-dev";
      shellHook = ''
        echo "Setting exported variable NVIM_DEV_DIR to directory's git repo root.
        Run \`nvimd\` to invoke nvim with \$NVIM_DEV_DIR/init.lua and NVIM_DEV_DIR prepended to runtimepath.
        This enables rapidly testing the neovim config in NVIM_DEV_DIR"
        export NVIM_DEV_DIR=$(git rev-parse --show-toplevel)
        echo "NVIM_DEV_DIR=$NVIM_DEV_DIR"
      '';

      packages = with pkgs; [
        (writeShellScriptBin "nvimd" ''nvim -u "$NVIM_DEV_DIR/init.lua" --cmd "set rtp^=$NVIM_DEV_DIR" $@'')
      ];
    };
  };
}
