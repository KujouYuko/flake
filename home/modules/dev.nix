{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cmake
    ninja
    nixd
    nixfmt
    protobuf
    rustup
    uv
  ];
}
