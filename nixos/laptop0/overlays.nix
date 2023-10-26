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

      telegram-desktop = prev.telegram-desktop.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/88d0ad6b9ad5c6146ff782e6c6d0937c2cbc32cb/0001-Disable-sponsored-messages.patch";
            hash = "sha256-o2Wxyag6hpEDgGm8FU4vs6aCpL9aekazKiNeZPLI9po=";
          })
        ];
      });

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
