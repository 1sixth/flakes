{ config, inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (inputs.berberman.packages.${prev.system})
        fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki;
      inherit (inputs.nix-index-database.packages.${prev.system})
        nix-index-with-db;
      inherit (inputs.nix-vscode-extensions.extensions.${prev.system}.forVSCodeVersion
        config.home-manager.users.one6th.programs.vscode.package.version)
        vscode-marketplace;

      vscodium = prev.vscodium.overrideAttrs (old: rec {
        version = "1.81.1.23222";
        src = prev.fetchurl {
          url = "https://github.com/VSCodium/vscodium/releases/download/${version}/VSCodium-linux-x64-${version}.tar.gz";
          hash = "sha256-pgblQPjf5aBJUTE4rbAfA9YAXLubG2qHFohGLqUapXM=";
        };
      });
    })
  ];
}
