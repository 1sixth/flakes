{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.base
    self.nixosModules.proxy.client
    self.nixosModules.resolved.china
    ./configuration.nix
    ./overlays.nix
  ];
  specialArgs = { inherit inputs self; };
}
