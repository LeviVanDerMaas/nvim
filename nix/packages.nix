{ pkgs, lib, ... }:

let
  plugins = import ./plugins.nix pkgs;
  init = builtins.readFile "${configDir}/init.lua";
  configDir = lib.cleanSourceWith {
    name = "neovim-config";
    src = lib.cleanSource ../.;
    filter = p: t: !(lib.elem (baseNameOf p) [
      ".gitignore"
      ".direnv"
      ".envrc"
      ".nvim.lua"
      "nix"
      "flake.nix"
      "flake.lock"
    ]);
  };

  callFlakePackage = lib.callPackageWith (pkgs // { inherit flakePkgs; });
  mkNvim = callFlakePackage ./mkNvim.nix {};
  flakePkgs = {
    inherit callFlakePackage mkNvim configDir;
    full = callFlakePackage mkNvim { inherit init configDir plugins; };
    default = flakePkgs.full;
    pluginsOnly = callFlakePackage mkNvim { inherit plugins; };
  };
in
flakePkgs
