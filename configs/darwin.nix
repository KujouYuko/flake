{
  lib,
  pkgs,
  user,
  ...
}:

{
  imports = [
    ../modules/pkgs.nix
  ];

  # Nix-Darwin replaces path_helper, so retain only core macOS integration
  # paths here. Third-party installers continue to own their entries in
  # /etc/paths.d; account-local shell configuration loads those entries.
  environment = {
    # Determinate supports local overrides only through nix.custom.conf;
    # Nix-Darwin must not take ownership of the generated nix.conf file.
    etc."nix/nix.custom.conf" = {
      text = ''
        cores = 2
        max-jobs = 4
        sandbox = true
        trusted-users = root ${user.name}
      '';

      # Determinate creates this comment-only file on installation. Its exact
      # default content is safe for nix-darwin to replace on first activation.
      knownSha256Hashes = [
        "3bd68ef979a42070a44f8d82c205cfd8e8cca425d91253ec2c10a88179bb34aa"
      ];
    };

    # Keep legacy NIX_PATH reproducible without exposing Flake inputs to the
    # system module; pkgs.path is the nixpkgs source selected for this host.
    variables.NIX_PATH = "nixpkgs=${pkgs.path}";

    # Preserve macOS Cryptex and Apple tool paths after Nix-Darwin disables
    # path_helper; keep each directory as a separate PATH list element.
    systemPath = lib.mkOrder 1150 [
      "/System/Cryptexes/App/usr/bin"
      "/Library/Apple/usr/bin"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit user; };
    users.${user.name} = import ../home/mac.nix;
  };

  # Determinate Nix owns the Nix binary, daemon, build users and generated
  # /etc/nix/nix.conf. Keeping this false prevents competing Nix daemons or
  # configuration ownership; Nix-Darwin still manages macOS packages and PATH.
  nix.enable = false;

  # Keep Touch ID support in sudo_local so macOS updates can continue to own
  # the vendor sudo PAM policy. Apple Watch authentication is supported by the
  # same pam_tid module when enabled in System Settings.
  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
  };

  system = {
    stateVersion = 6;
    primaryUser = user.name;
  };

  users.users.${user.name}.home = user.home;
}
