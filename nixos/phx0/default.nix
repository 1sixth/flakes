{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.base
    self.nixosModules.proxy.server
    self.nixosModules.qbittorrent-nox
    self.nixosModules.resolved.earth
    self.nixosModules.server
    self.nixosModules.stress-ng
    ./configuration.nix
  ];
  specialArgs = { inherit inputs self; };
}
