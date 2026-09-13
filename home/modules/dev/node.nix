{ config, pkgs, ... }:

let
  npmRoot = "${config.xdg.dataHome}/npm";
  pnpmRoot = "${config.xdg.dataHome}/pnpm";
in
{
  home = {
    packages = [
      pkgs.nodejs_26
      pkgs.pnpm
    ];

    sessionPath = [
      "${npmRoot}/bin"
      "${pnpmRoot}/bin"
    ];

    sessionVariables = {
      NPM_CONFIG_PREFIX = "${npmRoot}";
      NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/rc";

      # macOS config and registry/auth remain in ~/Library/Preferences/pnpm.
      PNPM_HOME = "${pnpmRoot}";
      PNPM_CONFIG_CACHE_DIR = "${config.xdg.cacheHome}/pnpm";
      PNPM_CONFIG_GLOBAL_DIR = "${pnpmRoot}/global";
      PNPM_CONFIG_STATE_DIR = "${config.xdg.stateHome}/pnpm";
      PNPM_CONFIG_STORE_DIR = "${pnpmRoot}/store";
    };
  };
}
