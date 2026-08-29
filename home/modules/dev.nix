{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cmake
    jdk25
    ninja
    nixd
    nixfmt
    protobuf
    rustup
    uv
  ];
}
