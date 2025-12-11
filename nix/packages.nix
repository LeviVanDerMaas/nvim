{ pkgs, lib, ... }@args:

let
  makeNvim = pkgs.callPackage ./nvim.nix;

  configDir = ../.;
  init = "${configDir}/init.lua";
  plugins = import ./plugins.nix args;
in
{
  default = makeNvim { inherit init configDir plugins; };
  pluginsOnly = makeNvim { inherit plugins; };
}
