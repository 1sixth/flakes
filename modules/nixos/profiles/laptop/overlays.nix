{ config, inputs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      inherit (inputs.nix-index-database.packages.${prev.system}) nix-index-with-db;
      inherit
        (inputs.nix-vscode-extensions.extensions.${prev.system}.forVSCodeVersion
          config.home-manager.users.one6th.programs.vscode.package.version
        )
        vscode-marketplace
        ;

      telegram-desktop = prev.telegram-desktop.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/b7a73c0b8a8b3527f69959ce3ceb35f8dbde8a8e/0001-Disable-sponsored-messages.patch";
            hash = "sha256-HeDH6tkkGx2XYTtzfo+gRee4BYxRiPKXQuftycl8Kvo=";
          })
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/b7a73c0b8a8b3527f69959ce3ceb35f8dbde8a8e/0002-Disable-saving-restrictions.patch";
            hash = "sha256-1YqbRNHgwwkPpmHE/KxoksTXoiD7dTGRiYrOWEW08jY=";
          })
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/b7a73c0b8a8b3527f69959ce3ceb35f8dbde8a8e/0003-Disable-invite-peeking-restrictions.patch";
            hash = "sha256-8mJD6LOjz11yfAdY4QPK/AUz9o5W3XdupXxy7kRrbC8=";
          })
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/b7a73c0b8a8b3527f69959ce3ceb35f8dbde8a8e/0004-Disable-accounts-limit.patch";
            hash = "sha256-PZWCFdGE/TTJ1auG1JXNpnTUko2rCWla6dYKaQNzreg=";
          })
          (prev.fetchpatch {
            url = "https://raw.githubusercontent.com/Layerex/telegram-desktop-patches/b7a73c0b8a8b3527f69959ce3ceb35f8dbde8a8e/0005-Option-to-disable-stories.patch";
            hash = "sha256-aSAjyFiOg8JLgYA3voijVvkGIgK93kNMx40vqHsvW8Y=";
          })
        ];
      });
    })
  ];
}
