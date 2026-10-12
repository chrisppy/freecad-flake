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
    inputs.devfmt.inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.devfmt.inputs.systems;

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
