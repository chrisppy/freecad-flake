# freecad-flake

A Nix Flake providing a custom, declarative FreeCAD wrapper module and packaging
system with dynamic plugin discovery and XML configuration injection.

**[Usage & configuration options →](./docs/usage.md)**

## Features

- **Dynamic Plugin Discovery**: Every pin in the `plugins` group of
  [`.tack/pins.toml`](./.tack/pins.toml) (e.g., `sheet-metal`, `fasteners`,
  `history`) becomes a boolean toggle option, generated with `lib.genAttrs`.
  Pins are fetched lazily, so only enabled plugins are downloaded.

- **XML Configuration Ingestion**: Inject custom baseline `user.cfg` and global
  `system.cfg` XML files directly through the launcher wrapper.

- **Custom FreeCAD Wrapper**: Utilizes `pkgs.freecad.customize` to produce a
  customized FreeCAD derivation (`programs.freecad.package`).

- **Flake Native**: Seamless integration with NixOS system configurations and
  Home Manager environments.

- **Pinned with [tack](https://github.com/manic-systems/tack)**: nixpkgs, devfmt
  and the plugins are pinned in `.tack/` instead of flake inputs, so the flake
  has no inputs and no `flake.lock`. Plugins follow upstream's newest versioned
  release tag, and a daily workflow opens a PR when any pin moves.

## Updating pins

```
just update                 # tack update: every pin
just update-input plugins   # only the plugins group
just look                   # what would move
```

To add a plugin, add a table to `.tack/pins.toml` and lock it with
`just update-input <name>`:

```toml
[inputs.plugins.<name>]
tag  = "v{version}"
type = "fetch"
url  = "github:<owner>/<repo>"
```

## Installation

Add `freecad-flake` to your `flake.nix` inputs:

```
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # No `inputs.*.follows` needed: freecad-flake has no flake inputs, and the
    # module builds with your own `pkgs`.
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
