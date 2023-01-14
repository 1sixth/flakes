{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.impermanence.nixosModules.impermanence
    inputs.nixos-cn.nixosModules.nixos-cn
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.dnscrypt-proxy2.earth
    self.nixosModules.qbittorrent-nox
    self.nixosModules.server
    self.nixosModules.v2ray.server
    ./configuration.nix
  ];
  specialArgs = { inherit inputs self; };
}
