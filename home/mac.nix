{
  config,
  lib,
  user,
  ...
}:

let
  timeMachineExclusions = [
    config.xdg.cacheHome
  ];
in
{
  imports = [
    ./modules/cli.nix
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

  # Exclude regenerable user data from Time Machine backups.
  home.activation.excludeFromTimeMachine = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    for path in ${lib.escapeShellArgs timeMachineExclusions}; do
      mkdir -p "$path"
      /usr/bin/tmutil addexclusion "$path"
    done
  '';
}
