{
  inputs,
  nixpkgs,
  self,
  system,
}:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.lix-module.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.base
    self.nixosModules.dns.china
    self.nixosModules.laptop
    self.nixosModules.proxy.client
    ./configuration.nix
  ];
  specialArgs = {
    inherit inputs self;
  };
}
