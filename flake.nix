{
  description = "my freecad module flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devfmt = {
      url = "github:chrisppy/devfmt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.devfmt.lib.mkFlake { inherit inputs; } {
      flake.flakeModules.default = ./modules/freecad.nix;

      perSystem =
        {
          pkgs,
          ...
        }:
        {
          packages.default = pkgs.freecad;
        };
    };
}
