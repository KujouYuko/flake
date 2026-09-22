# List recipes.
default:
    @just --list

# Update inputs and flake.lock.
update:
    nix flake update --flake .

# Evaluate and build checks for every declared platform.
check:
    nix flake check --all-systems

# Build and activate the Darwin configuration.
build-darwin:
    sudo -H nix run .#darwin-rebuild -- switch --flake .#default
