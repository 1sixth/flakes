{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.base
    self.nixosModules.dnscrypt-proxy2.china
    self.nixosModules.proxy.client
    ./configuration.nix
    {
      nixpkgs.overlays = [
        (final: prev: {
          inherit (inputs.berberman.packages.${prev.system})
            fcitx5-pinyin-moegirl fcitx5-pinyin-zhwiki;
          inherit (inputs.nix-index-database.packages.${prev.system})
            nix-index-with-db;
          inherit (inputs.nix-vscode-extensions.extensions.${prev.system}.forVSCodeVersion
            prev.vscodium.version)
            vscode-marketplace;
        })
      ];
    }
  ];
  specialArgs = { inherit inputs self; };
}
