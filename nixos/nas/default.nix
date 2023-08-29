{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.base
    self.nixosModules.dnscrypt-proxy2.china
    self.nixosModules.proxy.client
    self.nixosModules.qbittorrent-nox
    self.nixosModules.server
    ./configuration.nix
  ];
  specialArgs = { inherit inputs self; };
}
