{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fd
    git
    git-lfs
    htop
    just
    gnupg
    gnused
    ripgrep
    tree
    wget
  ];
}
