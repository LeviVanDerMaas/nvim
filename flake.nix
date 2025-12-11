{
  description = "Basic flake with Nix shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }: let
    arch = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${arch};
    lib = nixpkgs.lib;
  in {
    packages.${arch} = import ./nix/packages.nix pkgs;
    devShells.${arch} = import ./nix/devshells.nix pkgs;
  };
}
