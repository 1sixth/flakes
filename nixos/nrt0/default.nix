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
    self.nixosModules.dns.earth
    self.nixosModules.hath
    self.nixosModules.prometheus.client
    self.nixosModules.prometheus.server
    self.nixosModules.proxy.server
    self.nixosModules.server
    self.nixosModules.stress-ng
    self.nixosModules.syncthing
    self.nixosModules.tor
    self.nixosModules.traefik
    ./configuration.nix
  ];
  specialArgs = {
    inherit inputs self;
  };
}
