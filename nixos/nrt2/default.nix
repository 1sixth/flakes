{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.base
    self.nixosModules.dnscrypt-proxy2.earth
    self.nixosModules.hath
    self.nixosModules.server
    self.nixosModules.stress-ng
    self.nixosModules.v2ray.server
    ./configuration.nix
  ];
  specialArgs = { inherit inputs self; };
}
