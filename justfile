# List recipes.
default:
    @just --list

# Update inputs and flake.lock.
update:
    nix flake update --flake .

# Evaluate every declared platform without building checks.
check:
    nix flake check --no-build --all-systems

# Build and activate the Darwin configuration.
build-darwin:
    sudo -H nix run .#darwin-rebuild -- switch --flake .#default
