{ pkgs, lib, flakePkgs }:

{
  default = pkgs.mkShell {
    name = "nvim-config-dev";
    shellHook = ''
      echo "Setting exported variable NVIM_DEV_CONFIG to directory's git repo
      root. Run 'nvimd' to invoke nvim with VIMINIT set to, by default, run
      \$NVIM_DEV_CONFIG/init.lua and with the 'runtimepath' modified to only
      include NVIM_DEV_CONFIG and VIMRUNTIME.
      This enables rapidly testing the config in NVIM_DEV_CONFIG without having
      to rebuild the nix package, while isolated from all other sources of
      system- and user-level configuration."

      export NVIM_DEV_CONFIG=$(git rev-parse --show-toplevel)
      echo "NVIM_DEV_CONFIG=$NVIM_DEV_CONFIG"
    '';

    packages = with pkgs; [
      (writeShellScriptBin "nvimd" ''
        if [[ -v NVIM_DEV_CONFIG && -f $NVIM_DEV_CONFIG/init.lua ]]; then
          # If NVIM_DEV_CONFIG is null then so will VIMINIT be, which vim considers as unset
          export VIMINIT="''${VIMINIT-lua dofile('$NVIM_DEV_CONFIG/init.lua')}"
        fi

        ${lib.getExe flakePkgs.pluginsOnly} --cmd "set rtp=$NVIM_DEV_CONFIG,\$VIMRUNTIME" "$@"
      '')
    ];
  };
}
