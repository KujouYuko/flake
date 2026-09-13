{ pkgs, ... }:

let
  link = runtime: executable: ''
    ln -s ${runtime}/bin/${executable} "$out/bin/${executable}"
  '';

  # CPython packages expose overlapping unversioned executables. Keep 3.14 as
  # the default and expose only version-specific interfaces for other builds.
  pythonRuntimes = pkgs.runCommand "python-runtimes" { } ''
    mkdir -p "$out/bin"

    ${pkgs.lib.concatMapStrings (link pkgs.python314) [
      "python"
      "python-config"

      "python3"
      "python3-config"

      "python3.14"
      "python3.14-config"
    ]}

    ${pkgs.lib.concatMapStrings (link pkgs.python314FreeThreading) [
      "python3.14t"
      "python3.14t-config"
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
