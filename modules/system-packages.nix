{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fd
    git
    git-lfs
    just
    gnupg
    gnused
    ripgrep
    tree
    wget
  ];
}
