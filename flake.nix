{
  description = "my freecad module flake";

  # Inputs are pinned with tack in ./.tack (pins.toml, locked by
  # `tack update`), not here, so there is no flake.lock.
  outputs =
    { self, ... }@args:
    let
      pins = (import ./.tack) { overrides = args.tackOverrides or { }; };
      # Drop tack's own attrs so flake-parts only sees real inputs.
      inputs =
        removeAttrs pins [
          "_meta"
          "_patched"
          "__functor"
        ]
        // {
          inherit self;
        };
    in
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
