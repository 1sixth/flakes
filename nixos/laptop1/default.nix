{
  inputs,
  nixpkgs,
  self,
  system,
}:

nixpkgs.lib.nixosSystem {
  inherit system;
  extraModules = [ inputs.colmena.nixosModules.deploymentOptions ];
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
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
