set dotenv-load := false

# tack pins every input (.tack/pins.toml); nixpkgs only packages tack 1.0.x
tack := "nix run github:manic-systems/tack/v2.0.0 --"

# List available recipes
default:
    @just --list

# Build the default package (FreeCAD)
build:
    nix build

# Run FreeCAD from the flake
run *args:
    nix run . -- {{ args }}

# Check flake outputs and evaluation
check:
    nix flake check

# Format Nix and other configured files
fmt:
    nix fmt

# Check formatting without modifying files (the flake's treefmt check, run on a copy)
fmt-check:
    nix build --no-link ".#checks.$(nix eval --impure --raw --expr builtins.currentSystem).treefmt"

# Show the flake's outputs
show:
    nix flake show

# Update every tack pin (nixpkgs, devfmt and the plugins)
update:
    {{ tack }} update

# Update specific pins or groups, e.g. `just update-input plugins`
update-input +inputs:
    {{ tack }} update {{ inputs }}

# Show which pins have newer upstream revisions or tags
look:
    {{ tack }} look

# Run any other tack command
tack *args:
    {{ tack }} {{ args }}

# Check formatting and the flake
verify: fmt-check check

# Remove build result symlinks
clean:
    rm -f result result-*
