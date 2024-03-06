{
  inputs,
  nixpkgs,
  self,
  system,
}:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.base
    self.nixosModules.prometheus.client
    self.nixosModules.prometheus.server
    self.nixosModules.proxy.server
    self.nixosModules.resolved.earth
    self.nixosModules.server
    ./configuration.nix
  ];
  specialArgs = {
    inherit inputs self;
  };
}
