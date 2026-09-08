{ pkgs, ... }:

{
  home.packages = with pkgs; [
    fastfetch
  ];

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
