{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.dnscrypt-proxy2.china
    self.nixosModules.qbittorrent-nox
    self.nixosModules.server
    self.nixosModules.sing-box.client
    ./configuration.nix
  ];
  specialArgs = { inherit inputs self; };
}
