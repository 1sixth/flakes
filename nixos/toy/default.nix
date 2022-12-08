{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    {
      nixpkgs.overlays = [
        inputs.deploy-rs.overlay
        self.overlays.sway
      ];

      nix.registry.nixpkgs.flake = inputs.nixpkgs;
    }
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.dnscrypt-proxy2.china
    self.nixosModules.v2ray.client
    ./configuration.nix
  ];
}
