# freecad-flake

A Nix Flake providing a custom, declarative FreeCAD wrapper module and packaging
system with dynamic plugin discovery and XML configuration injection.

**[Usage & configuration options →](./docs/usage.md)**

## Features

- **Dynamic Plugin Discovery**: Automatically imports and builds workbench
  plugins located in `./plugins/*.nix` (e.g., `sheet-metal`, `fasteners`,
  `history`), generating boolean toggle options programmatically via
  `lib.genAttrs`.

- **XML Configuration Ingestion**: Inject custom baseline `user.cfg` and global
  `system.cfg` XML files directly through the launcher wrapper.

- **Custom FreeCAD Wrapper**: Utilizes `pkgs.freecad.customize` to produce a
  customized FreeCAD derivation (`programs.freecad.package`).

- **Flake Native**: Seamless integration with NixOS system configurations and
  Home Manager environments.

## Installation

Add `freecad-flake` to your `flake.nix` inputs:

```
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    freecad-flake.url = "github:chrisppy/freecad-flake";
  };

  outputs = { self, nixpkgs, freecad-flake, ... }@inputs: {
    # Your flake outputs...
  };
}
```

## License

This project is licensed under the **GPL-3.0-only** license. See the
[LICENSE](./LICENSE) file for details.
