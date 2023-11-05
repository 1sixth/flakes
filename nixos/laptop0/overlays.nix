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

      poetry = prev.poetry.overrideAttrs (old: {
        postInstall =
          let
            # 'xyz'' => "xyz"'
            match = "'([^']+)''";
            replace = "\"$1\"'";
          in
          ''
            installShellCompletion --cmd poetry \
              --bash <($out/bin/poetry completions bash) \
              --fish <($out/bin/poetry completions fish | ${prev.sd}/bin/sd "${match}" "${replace}") \
              --zsh <($out/bin/poetry completions zsh) \
          '';
      });

      telegram-desktop = prev.telegram-desktop.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/2457ef3a2d3ff94dfa4b0a73ea4c51bad4b3f14b/0001-Disable-sponsored-messages.patch";
            hash = "sha256-o2Wxyag6hpEDgGm8FU4vs6aCpL9aekazKiNeZPLI9po=";
          })
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/2457ef3a2d3ff94dfa4b0a73ea4c51bad4b3f14b/0002-Disable-saving-restrictions.patch";
            hash = "sha256-sQsyXlvhXSvouPgzYSiRB8ieICo3GDXWH5MaZtBjtqw=";
          })
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/2457ef3a2d3ff94dfa4b0a73ea4c51bad4b3f14b/0003-Disable-invite-peeking-restrictions.patch";
            hash = "sha256-8mJD6LOjz11yfAdY4QPK/AUz9o5W3XdupXxy7kRrbC8=";
          })
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/2457ef3a2d3ff94dfa4b0a73ea4c51bad4b3f14b/0004-Disable-accounts-limit.patch";
            hash = "sha256-PZWCFdGE/TTJ1auG1JXNpnTUko2rCWla6dYKaQNzreg=";
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
