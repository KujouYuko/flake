{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    fd
    git
    git-lfs
    just
    gnupg
    ripgrep
    tree
    wget
  ];
}
