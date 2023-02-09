{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.dnscrypt-proxy2.china
    self.nixosModules.sing-box.client
    ./configuration.nix
  ];
  specialArgs = { inherit inputs self; };
}
