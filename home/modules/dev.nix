{ pkgs, ... }:

{
  imports = [
    ./dev/java.nix
    ./dev/node.nix
    ./dev/python.nix
  ];

  home.packages = with pkgs; [
    cmake
    ninja
    nixd
    nixfmt
    protobuf
    rustup
  ];
}
