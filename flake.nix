{
  description = "somewhat somehow deterministic";

  inputs = {
    deploy-rs = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
      url = "github:serokell/deploy-rs";
    };
    flake-compat = {
      flake = false;
      url = "github:edolstra/flake-compat";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
      url = "github:nix-community/home-manager";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # libtorrent-rasterbar 2.0.4
    nixpkgs-libtorrent-rasterbar.url = "github:NixOS/nixpkgs?rev=b42f0a0b45d33dec4a25508ea5293a4a016697a9";
    # qbittorrent 4.3.9
    nixpkgs-qbittorrent-nox.url = "github:NixOS/nixpkgs?rev=56137af9f1b6f89329d55de169e0eefee57e8263";
    sops-nix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
      url = "github:Mic92/sops-nix";
    };
  };

  outputs = inputs@{ nixpkgs, self, ... }:

    {
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

      deploy = {
        autoRollback = false;
        magicRollback = false;
        nodes = builtins.mapAttrs
          (name: value: {
            hostname = "${name}.9875321.xyz";
            profiles.system.path = inputs.deploy-rs.lib.${value.pkgs.system}.activate.nixos
              self.nixosConfigurations.${name};
          })
          # toy is my local machine.
          (nixpkgs.lib.filterAttrs (name: value: name != "toy") self.nixosConfigurations);
        sshUser = "root";
      };

      nixosConfigurations = {
        las0 = import ./nixos/las0 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nas = import ./nixos/nas { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nrt0 = import ./nixos/nrt0 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
        nrt1 = import ./nixos/nrt1 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nrt2 = import ./nixos/nrt2 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nrt3 = import ./nixos/nrt3 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
        nrt4 = import ./nixos/nrt4 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nrt5 = import ./nixos/nrt5 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        toy = import ./nixos/toy { system = "x86_64-linux"; inherit self nixpkgs inputs; };
      };

      nixosModules = import ./modules;

      overlays = import ./overlays { inherit inputs; };
    };
}
