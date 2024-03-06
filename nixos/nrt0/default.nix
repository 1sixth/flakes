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
    self.nixosModules.hath
    self.nixosModules.prometheus.client
    self.nixosModules.proxy.server
    self.nixosModules.resolved.earth
    self.nixosModules.server
    self.nixosModules.stress-ng
    self.nixosModules.tor
    ./configuration.nix
  ];
  specialArgs = {
    inherit inputs self;
  };
}
