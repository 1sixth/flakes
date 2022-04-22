{ inputs, nixpkgs, self, system, }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    {
      nixpkgs.overlays = [
        self.overlays.deploy-rs
        self.overlays.fcitx5
        self.overlays.qliveplayer
        self.overlays.polymc
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
