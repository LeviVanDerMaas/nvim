{ pkgs, lib, ... }:

let
  mkNvim = import ./mkNvim.nix pkgs;
  plugins = import ./plugins.nix pkgs;

  init = builtins.readFile "${configDir}/init.lua";
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

  flakePkgs = {
    inherit mkNvim;
    default = mkNvim { inherit init configDir plugins; };
    pluginsOnly = mkNvim { inherit plugins; };
    callFlakePackage = lib.callPackageWith (pkgs // { inherit flakePkgs; });
  };
in
flakePkgs
