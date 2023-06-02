{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.base
    self.nixosModules.dnscrypt-proxy2.china
    self.nixosModules.v2ray.client
    ./configuration.nix
  ];
  specialArgs = { inherit inputs self; };
}
