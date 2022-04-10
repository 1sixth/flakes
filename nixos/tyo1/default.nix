{ inputs, nixpkgs, self, system, }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.dnscrypt-proxy2.earth
    self.nixosModules.hath
    self.nixosModules.server
    self.nixosModules.tor
    self.nixosModules.v2ray.server
    ./configuration.nix
  ];
}
