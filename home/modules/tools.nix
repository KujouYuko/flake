{ pkgs, ... }:

{
  home.packages = with pkgs; [
    android-tools
    fastfetch
    ffmpeg
  ];
}
