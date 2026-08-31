{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    git-lfs
    gnupg
    ripgrep
    tree
    wget
  ];
}
