{ inputs, nixpkgs, self, system, }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    {
      nixpkgs.overlays = [
        inputs.deploy-rs.overlay
        inputs.polymc.overlay
        self.overlays.fcitx5
        self.overlays.qliveplayer
        self.overlays.sway
      ];
    }
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.dnscrypt-proxy2.china
    self.nixosModules.v2ray.client
    ./configuration.nix
  ];
}
