{
  description = "my freecad module flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    devfmt = {
      url = "github:chrisppy/devfmt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      imports = [
        inputs.devfmt.flakeModules.default
      ];
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
