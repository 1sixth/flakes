{ inputs, nixpkgs, self, system, }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    { nixpkgs.overlays = [ self.overlays.qbittorrent-nox ]; }
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.dnscrypt-proxy2.earth
    self.nixosModules.qbittorrent-nox
    self.nixosModules.server
    self.nixosModules.tor
    self.nixosModules.v2ray.server
    ./configuration.nix
  ];
}
