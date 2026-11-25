# Changelog

All notable changes to freecad-flake are recorded here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

There are no tagged releases yet, so changes are grouped by date under
Unreleased. Routine flake input updates and formatting commits are left out.

## Unreleased

### 2026-11-07

#### Added

- justfile.

#### Changed

- Usage and options moved from the README to [docs/usage.md](./docs/usage.md).

### 2026-10-25

#### Added

- README.

### 2026-10-17

#### Added

- Flake inputs are updated by a scheduled workflow.

### 2026-10-12

- Initial release: a FreeCAD wrapper module for NixOS and Home Manager built on
  `pkgs.freecad.customize`, with `user.cfg` and `system.cfg` injection and
  plugins discovered from `plugins/` (sheet-metal, fasteners, history).
