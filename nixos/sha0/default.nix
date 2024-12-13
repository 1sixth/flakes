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
    self.nixosModules.proxy.client
    self.nixosModules.server
    self.nixosModules.syncthing
    ./configuration.nix
  ];
  specialArgs = {
    inherit inputs self;
  };
}
