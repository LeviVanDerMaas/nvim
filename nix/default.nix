{
  pkgs,
  lib,

  baseNeovimPackage ? pkgs.neovim-unwrapped,
  extraPackages ? [],
  plugins ? [],
}:

let
  # makeNeovimConfig produces an attrset that is to be passed to
  # wrapNeovimUnstable. It does this by merging its input attrset with another
  # one it generates based on the input attributes (traditional merging so the
  # result may OVERWRITE input attributes). Currently the only real
  # functionality it has is to generate a custom `wrapperArgs` attribute based
  # on the passed in `extraLuaPackages` attribute and everything else is passed
  # straight, but I guess the idea is that in the future it might abstract more
  # complex configuration without wrapping the program yet.
  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    customLuaRC = ../init.lua;
    vimAlias = true;
    viAlias = true;
    # TODO: Figure out why withPython3 and withRuby are true by default? It
    # doesn't seem like they do anything special compared to the other off by
    # default providers. Maybe disable them.
  };

  pluginExtraPackages = builtins.concatMap (p: p.extraPackages or []) plugins;

  # Might get weird if you have package with duplicate paths (e.g. two different
  # versions of the same package), seems like packages later in 'paths' overwrite
  # already existing paths of older ones.
  joinedExtraPackages = pkgs.symlinkJoin {
    name = "extra-neovim-packages";
    paths = extraPackages ++ pluginExtraPackages;
  };

  # Arguments are defined in pkgs/applications/editors/neovim/wrapper.nix
  wrappedNeovim = pkgs.wrapNeovimUnstable baseNeovimPackage (
    neovimConfig // {
      wrapperArgs = neovimConfig.wrapperArgs ++ [
        "--prefix"
        "PATH"
        ":"
        "${lib.makeBinPath [ joinedExtraPackages ]}"
        
        "--add-flags"
        "--cmd 'set rtp^=${./..}'"
      ];
    }
  );
in 
  wrappedNeovim
