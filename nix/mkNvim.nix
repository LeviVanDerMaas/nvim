{ pkgs, lib }:

{
  baseNeovimPackage ? pkgs.neovim-unwrapped,
  # Given packages will be prefixed to the nvim package's PATH via symlinkJoin.
  extraPackages ? [],
  # Plugin spec like what wrapNeovimUnstable expects, but additionally:
  # - A plugin with an 'extraPackages' attribute has its value appended to
  #   the general 'extraPackages' argument of this function.
  # - A plugin with a 'dependsOn' attribute will append listed plugins
  #   to the general 'plugins' argument of this function (allows nesting).
  plugins ? [],
  init ? null,
  configDir ? null
}:
let
  flattenPlugins = lib.concatMap (
    p:
      let
        p' = [ (lib.removeAttrs p [ "dependsOn" ]) ];
        deps = lib.optionals (p ? dependsOn) (flattenPlugins p.dependsOn);
      in
      p' ++ deps
  );

  nvimPkgConfig = pkgs.neovimUtils.makeNeovimConfig {
    ${if init == null then null else "customLuaRC"} = init;
    plugins = lib.unique (flattenPlugins plugins);
    vimAlias = true;
    viAlias = true;
  };

  pluginExtraPackages = lib.concatMap (p: p.extraPackages or []) plugins;
  extraPackagesDrv = pkgs.symlinkJoin {
    name = "extra-neovim-packages";
    paths = lib.unique (extraPackages ++ pluginExtraPackages);
  };
in
pkgs.wrapNeovimUnstable baseNeovimPackage (
  nvimPkgConfig // {
    wrapperArgs = nvimPkgConfig.wrapperArgs ++ [
      "--prefix"
      "PATH"
      ":"
      "${lib.makeBinPath [ extraPackagesDrv ]}"

      "--add-flags"
      "${if configDir == null then "" else "--cmd 'set rtp^=${configDir}'"}"
    ];
  }
)
