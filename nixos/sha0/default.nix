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
    self.nixosModules.dns.china
    self.nixosModules.profiles.base
    self.nixosModules.profiles.server
    self.nixosModules.proxy.client
    self.nixosModules.syncthing
    ./configuration.nix
  ];
  specialArgs = {
    inherit inputs self;
  };
}
