{ inputs, nixpkgs, self, system, }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    { nixpkgs.overlays = [ self.overlays.qbittorrent-nox ]; }
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.dnscrypt-proxy2.china
    self.nixosModules.qbittorrent-nox
    self.nixosModules.server
    self.nixosModules.v2ray.client
    ./configuration.nix
  ];
}
