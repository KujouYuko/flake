{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gnupg
    ripgrep
    tree
    wget
  ];
}
