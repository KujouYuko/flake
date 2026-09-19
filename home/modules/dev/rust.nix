{ config, pkgs, ... }:

{
  home = {
    packages = [
      pkgs.rustup
    ];

    sessionVariables = {
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    };
  };
}
