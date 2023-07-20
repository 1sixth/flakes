{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.base
    self.nixosModules.dnscrypt-proxy2.earth
    self.nixosModules.qbittorrent-nox
    self.nixosModules.proxy.server
    self.nixosModules.server
    self.nixosModules.stress-ng
    ./configuration.nix
  ];
  specialArgs = { inherit inputs self; };
}
