{
  description = "somewhat somehow deterministic";

  inputs = {
    berberman = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:berberman/flakes";
    };
    deploy-rs = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:serokell/deploy-rs";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    hydra = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:NixOS/hydra";
    };
    nixos-cn = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nixos-cn/flakes";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    # libtorrent-rasterbar 2.0.4
    nixpkgs-libtorrent-rasterbar.url = "github:NixOS/nixpkgs?rev=b42f0a0b45d33dec4a25508ea5293a4a016697a9";
    # qbittorrent 4.3.9
    nixpkgs-qbittorrent-nox.url = "github:NixOS/nixpkgs?rev=56137af9f1b6f89329d55de169e0eefee57e8263";
    # sway IME support
    nixpkgs-sway.url = "github:NickCao/nixpkgs";
    polymc = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:PolyMC/PolyMC";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
  };

  outputs =
    inputs@{ berberman
    , deploy-rs
    , home-manager
    , hydra
    , nixos-cn
    , nixpkgs
    , nixpkgs-libtorrent-rasterbar
    , nixpkgs-qbittorrent-nox
    , nixpkgs-sway
    , self
    , polymc
    , sops-nix
    }:

    {
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

      deploy = {
        nodes = (inputs.nixpkgs.lib.attrsets.genAttrs [ "hel" "nas" "tyo1" "tyo2" ]
          (name: {
            hostname = "${name}.9875321.xyz";
            profiles.system.path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations."${name}";
          })) // {
          # This is the only non x86-64 machine, so I didn't bother to write branching above.
          tyo0 = {
            hostname = "tyo0.9875321.xyz";
            profiles.system.path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.tyo0;
          };
        };
        sshUser = "root";
      };

      hydraJobs = {
        hel = self.nixosConfigurations.hel.config.system.build.toplevel;
        toy = self.nixosConfigurations.toy.config.system.build.toplevel;
      };

      nixosConfigurations = {
        hel = import ./nixos/hel { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nas = import ./nixos/nas { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        toy = import ./nixos/toy { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        tyo0 = import ./nixos/tyo0 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
        tyo1 = import ./nixos/tyo1 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        tyo2 = import ./nixos/tyo2 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
      };

      nixosModules = import ./modules;

      overlays = import ./overlays { inherit inputs; };
    };
}
