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
    self.nixosModules.laptop
    self.nixosModules.proxy.client
    ./configuration.nix
  ];
  specialArgs = {
    inherit inputs self;
  };
}
