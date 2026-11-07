set dotenv-load := false

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

# Update all flake inputs
update:
    nix flake update

# Update a specific flake input
update-input input:
    nix flake update {{ input }}

# Check formatting and the flake
verify: fmt-check check

# Remove build result symlinks
clean:
    rm -f result result-*
