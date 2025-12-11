{ pkgs, ... }@args:

let
  nvimWithPlugins = (import ./packages.nix args).pluginsOnly;
in
{
  default = pkgs.mkShell {
    name = "nvim-config-dev";
    shellHook = ''
      echo "Setting exported variable NVIM_DEV_CONFIG to directory's git repo root.
      Run \`nvimd\` to invoke base nvim with -u \$NVIM_DEV_CONFIG/init.lua,
      NVIM_DEV_DIR prepended to runtimepath, and the --clean flag.
      This enables rapidly testing the neovim config in NVIM_DEV_DIR"

      export NVIM_DEV_CONFIG=$(git rev-parse --show-toplevel)
      echo "NVIM_DEV_CONFIG=$NVIM_DEV_CONFIG"
    '';

    packages = with pkgs; [
      (writeShellScriptBin "nvimd" ''
        ${nvimWithPlugins} -u --clean "$NVIM_DEV_CONFIG/init.lua" --cmd "set rtp^=$NVIM_DEV_CONFIG" $@
      '')
    ];
  };
}
