{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  bash,
  coreutils,
}:

let
  version = "1.55.0";

  src = fetchurl {
    url = "https://github.com/tw93/Mole/archive/refs/tags/V${version}.tar.gz";
    hash = "sha256-pxroLE6ZuBd8d+L4GrMABc8QDNFCojUfdsid6oD9AcI=";
    name = "Mole-${version}.tar.gz";
  };

  binaries = fetchurl {
    url = "https://github.com/tw93/Mole/releases/download/V${version}/binaries-darwin-arm64.tar.gz";
    hash = "sha256-uWNAT3mZMYiFqGwNTUq1UCvV41zHR36qW4ZZlAIHZCE=";
    name = "mole-binaries-darwin-arm64-${version}.tar.gz";
  };
in
stdenvNoCC.mkDerivation {
  pname = "mole-cleaner";
  inherit version src;

  sourceRoot = "Mole-${version}";

  # The install phase consumes the release's prebuilt Darwin helpers; running
  # Mole's default Makefile would only attempt an unnecessary Go module build.
  dontBuild = true;

  postPatch = ''
    # compgen is a Bash builtin, but Mole's optimization tasks can be sourced
    # from a shell that is not Bash. Invoke it through the packaged Bash rather
    # than relying on the caller's interpreter or PATH.
    substituteInPlace lib/optimize/tasks.sh \
      --replace-fail 'done < <(compgen -G "$pattern" || true)' \
        "done < <(${lib.getExe bash} -c 'compgen -G \"\$1\"' -- \"\$pattern\" || true)"

    # Bash cannot retain NUL bytes in shell strings. Its =~ operator calls
    # POSIX regcomp; for Nix Bash on Darwin this reaches Darwin's regex
    # implementation, which rejects the resulting empty pattern. The decoded
    # value has already passed through command substitution, so neither check
    # can detect NUL bytes anyway.
    substituteInPlace lib/uninstall/batch.sh \
      --replace-fail "[[ \"\$decoded\" =~ \$'\\0' ]]" "false"
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 mole $out/libexec/mole/mole
    cp -r bin lib $out/libexec/mole
    tar -xzf ${binaries} -C $out/libexec/mole/bin
    mv $out/libexec/mole/bin/analyze-darwin-arm64 $out/libexec/mole/bin/analyze-go
    mv $out/libexec/mole/bin/status-darwin-arm64 $out/libexec/mole/bin/status-go

    patchShebangs $out/libexec/mole

    # This timeout is private to Mole; it is exposed only by the wrapper below.
    mkdir -p $out/libexec/mole/nix-bin
    ln -s ${lib.getExe' coreutils "timeout"} $out/libexec/mole/nix-bin/timeout

    makeWrapper $out/libexec/mole/mole $out/bin/mo \
      --run '
        case "''${1:-}" in
          update|remove)
            echo "mo $1 is unsupported for Nix-installed Mole." >&2
            exit 1
            ;;
        esac
        # Mole expects BSD sed, so macOS utilities precede the inherited PATH.
        export PATH=$out/libexec/mole/nix-bin:/usr/bin:/bin:''${PATH:-}
      '

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    test -x $out/bin/mo
    test -x $out/libexec/mole/bin/analyze-go
    test -x $out/libexec/mole/bin/status-go

    runHook postInstallCheck
  '';

  meta = {
    description = "CLI tool for cleaning and optimizing macOS systems";
    homepage = "https://github.com/tw93/Mole";
    changelog = "https://github.com/tw93/Mole/releases/tag/V${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "mo";
    platforms = [ "aarch64-darwin" ];
  };
}
