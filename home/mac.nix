{ config, user, ... }:

{
  imports = [
    ./modules/dev.nix
    ./modules/fonts.nix
    ./modules/git.nix
    ./modules/shell.nix
    ./modules/tools.nix
  ];

  manual.manpages.enable = false;

  home = {
    username = user.name;
    homeDirectory = user.home;
    stateVersion = "26.05";
  };
}
