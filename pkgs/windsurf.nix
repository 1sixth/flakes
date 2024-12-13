{
  stdenv,
  nixpkgs,
  callPackage,
  fetchurl,
  nixosTests,
  commandLineArgs ? "",
  useVSCodeRipgrep ? stdenv.hostPlatform.isDarwin,
}:
# https://windsurf-stable.codeium.com/api/update/linux-x64/stable/latest
callPackage "${nixpkgs}/pkgs/applications/editors/vscode/generic.nix" {
  inherit commandLineArgs useVSCodeRipgrep;

  version = "1.10.0";
  pname = "windsurf";

  executableName = "windsurf";
  longName = "Windsurf";
  shortName = "windsurf";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/c418a14b63f051e96dafb37fe06f1fe0b10ba3c8/Windsurf-linux-x64-1.1.0.tar.gz";
    hash = "sha256-fsDPzHtAmQIfFX7dji598Q+KXO6A5F9IFEC+bnmQzVU=";
  };

  sourceRoot = "Windsurf";

  tests = nixosTests.vscodium;

  updateScript = "nil";

  meta = {
    description = "The first agentic IDE, and then some";
  };
}
