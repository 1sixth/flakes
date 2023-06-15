{ inputs, nixpkgs, self, system }:

nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    inputs.home-manager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.sops-nix.nixosModules.sops
    self.nixosModules.base
    self.nixosModules.dnscrypt-proxy2.china
    self.nixosModules.v2ray.client
    ./configuration.nix
    {
      nixpkgs.overlays = [
        (final: prev: {
          inherit (inputs.hyprwm-contrib.packages.${prev.system}) grimblast;
          inherit (inputs.nix-index-database.packages.${prev.system}) nix-index-with-db;

          hyprland = prev.hyprland.override {
            hidpiXWayland = true;
          };

          waybar = prev.waybar.overrideAttrs (old: {
            postPatch = ''
              sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
            '';
            postFixup = ''
              wrapProgram $out/bin/waybar \
                --suffix PATH : ${inputs.nixpkgs.lib.makeBinPath [ final.hyprland ]}
            '';
            mesonFlags = old.mesonFlags ++ [ "-Dexperimental=true" ];
          });
        })
      ];
    }
  ];
  specialArgs = { inherit inputs self; };
}
