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
    self.nixosModules.dns
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
