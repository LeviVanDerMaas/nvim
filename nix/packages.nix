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
    pkgs.wrapNeovimUnstable baseNeovimPackage (
      nvimPkgConfig // {
        wrapperArgs = nvimPkgConfig.wrapperArgs ++ [
          "--prefix"
          "PATH"
          ":"
          "${lib.makeBinPath [ joinedExtraPackages ]}"

          "--add-flags"
          "${if configDir == null then "" else "--cmd 'set rtp^=${configDir}'"}"
        ];
      }
    );

  # TODO: Maybe wanna use filter attribute to filter out unneeded paths like nix and flake
  # But idk if this is worth it, since flakes are copied in full to the store anyway,
  # the hash of this flake and the hash of this path will probably be the same, at which point
  # we might as well not bother otherwise we just end up duplicating stuff to the store unnecesarily.
  configDir = lib.cleanSourceWith {
    name = "neovim-config";
    src = lib.cleanSource ../.;
    filter = p: t: !(lib.elem (baseNameOf p) [
      ".gitignore"
      "nix"
      "flake.nix"
      "flake.lock"
    ]);
  };
  init = builtins.readFile "${configDir}/init.lua";
  plugins = import ./plugins.nix pkgs;

  flakePkgs = {
    default = mkNvim { inherit init configDir plugins; };
    pluginsOnly = mkNvim { inherit plugins; };

    callFlakePackage = lib.callPackageWith (pkgs // { inherit flakePkgs; });
  };
in
flakePkgs
