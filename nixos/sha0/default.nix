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
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.base
    self.nixosModules.dns.china
    self.nixosModules.proxy.client
    self.nixosModules.server
    self.nixosModules.syncthing
    ./configuration.nix
  ];
  specialArgs = {
    inherit inputs self;
  };
}
