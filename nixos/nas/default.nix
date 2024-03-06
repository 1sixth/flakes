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
    self.nixosModules.proxy.client
    self.nixosModules.qbittorrent-nox
    self.nixosModules.resolved.china
    self.nixosModules.server
    ./configuration.nix
  ];
  specialArgs = {
    inherit inputs self;
  };
}
