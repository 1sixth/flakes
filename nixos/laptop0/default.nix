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
          inherit (inputs.nix-index-database.packages.${prev.system}) nix-index-with-db;
        })
      ];
    }
  ];
  specialArgs = { inherit inputs self; };
}
