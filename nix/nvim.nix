{
  pkgs,
  lib,
  baseNeovimPackage ? pkgs.neovim-unwrapped,
  plugins ? [],
  extraPackages ? [],
  init ? null,
  configDir ? null
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
  # TODO: Figure out why withPython3 and withRuby are true by default? It
  # doesn't seem like they do anything special compared to the other off by
  # default providers. Maybe disable them.
  nullOr = n: v: if n == null then n else v;

  neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
    inherit plugins;
    ${nullOr init "customLuaRC"} = init;
    vimAlias = true;
    viAlias = true;
  };

  # Concat extraPackages from plugins with general extraPackages, then join em
  # all in one derivation for easy organization and to prevent bloating rtp.
  # Duplicate packages just overwrite themselves witht their own file path so no issue there.
  # Might technically get weird if multiple different packages have the same file paths.
  pluginExtraPackages = builtins.concatMap (p: p.extraPackages or []) plugins;
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
        "${nullOr configDir "--cmd 'set rtp^=${configDir}'"}"
      ];
    }
  );
in
  wrappedNeovim
