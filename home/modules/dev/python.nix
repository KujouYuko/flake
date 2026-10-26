{ pkgs, ... }:

let
  link = runtime: executable: ''
    ln -s ${runtime}/bin/${executable} "$out/bin/${executable}"
  '';

  # CPython packages expose overlapping unversioned executables. Keep 3.15 as
  # the default and expose only version-specific interfaces for other builds.
  pythonRuntimes = pkgs.runCommand "python-runtimes" { } ''
    mkdir -p "$out/bin"

    ${pkgs.lib.concatMapStrings (link pkgs.python312) [
      "python3.12"
      "python3.12-config"
    ]}


    ${pkgs.lib.concatMapStrings (link pkgs.python314) [
      "python3.14"
      "python3.14-config"
    ]}

    ${pkgs.lib.concatMapStrings (link pkgs.python315) [
      "python"
      "python-config"

      "python3"
      "python3-config"

      "python3.15"
      "python3.15-config"
    ]}

    ${pkgs.lib.concatMapStrings (link pkgs.python314FreeThreading) [
      "python3.14t"
      "python3.14t-config"
    ]}

    ${pkgs.lib.concatMapStrings (link pkgs.python315FreeThreading) [
      "python3.15t"
      "python3.15t-config"
    ]}
  '';
in
{
  home = {
    sessionVariables.UV_NO_MANAGED_PYTHON = "1";

    packages = [
      pkgs.uv
      pythonRuntimes
    ];
  };
}
