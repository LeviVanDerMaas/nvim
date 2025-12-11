{ pkgs, lib, ... }:

let
  mkNvim =
    {
      baseNeovimPackage ? pkgs.neovim-unwrapped,
      # Given packages will be prefixed to the nvim package's PATH via symlinkJoin.
      extraPackages ? [],
      # Plugin spec like what wrapNeovimUnstable expects, but a plugin with an
      # 'extraPackages' attribute has its value appended to the general
      # 'extraPackages' argument of this function
      plugins ? [],
      init ? null,
      configDir ? null
    }:
    let
      nvimPkgConfig = pkgs.neovimUtils.makeNeovimConfig {
        ${if init == null then null else "customLuaRC"} = init;
        inherit plugins;
        vimAlias = true;
        viAlias = true;
      };

      pluginExtraPackages =  lib.concatMap (p: p.extraPackages or []) plugins;
      joinedExtraPackages = pkgs.symlinkJoin {
        name = "extra-neovim-packages";
        paths = extraPackages ++ pluginExtraPackages;
      };
    in
    pkgs.wrapNeovimUnstable baseNeovimPackage {
      wrapperArgs = nvimPkgConfig.wrapperArgs ++ [
        "--prefix"
        "PATH"
        ":"
        "${lib.makeBinPath [ joinedExtraPackages ]}"

        "--add-flags"
        "${if configDir == null then "" else "--cmd 'set rtp^=${configDir}'"}"
      ];
    };

  configDir = ../.;
  init = "${configDir}/init.lua";
  plugins = import ./plugins.nix pkgs;

  flakePkgs = {
    default = mkNvim { inherit init configDir plugins; };
    pluginsOnly = mkNvim { inherit plugins; };

    callFlakePackage = lib.callPackageWith (pkgs // flakePkgs);
  };
in
flakePkgs
