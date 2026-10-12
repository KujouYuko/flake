{ lib, pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      android-tools
      ffmpeg
      imagemagick
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ mole ];
}
