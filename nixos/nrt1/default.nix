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
    self.nixosModules.dns.earth
    self.nixosModules.hath
    self.nixosModules.profiles.base
    self.nixosModules.profiles.server
    self.nixosModules.prometheus.client
    self.nixosModules.proxy.server
    self.nixosModules.qbittorrent-nox
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
