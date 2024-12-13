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
    self.nixosModules.base
    self.nixosModules.prometheus.client
    self.nixosModules.prometheus.server
    self.nixosModules.proxy.server
    self.nixosModules.server
    self.nixosModules.traefik
    ./configuration.nix
  ];
  specialArgs = {
    inherit inputs self;
  };
}
