{
  inputs,
  nixpkgs,
  self,
  system,
}:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.lix-module.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.dns.china
    self.nixosModules.profiles.base
    self.nixosModules.profiles.laptop
    self.nixosModules.proxy.client
    ./configuration.nix
    ./overlays.nix
  ];
  specialArgs = {
    inherit inputs self;
  };
}
