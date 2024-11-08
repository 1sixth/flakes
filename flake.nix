{
  description = "somewhat somehow deterministic";

  inputs = {
    colmena = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        stable.follows = "nixpkgs";
      };
      url = "github:zhaofengli/colmena";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    hyprland = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:hyprwm/Hyprland";
    };
    impermanence.url = "github:nix-community/impermanence";
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };
    nix-vscode-extensions = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-vscode-extensions";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    sops-nix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
      url = "github:Mic92/sops-nix";
    };
  };

  outputs =
    inputs@{ nixpkgs, self, ... }:

    {
      colmena =
        {
          meta = {
            nixpkgs = import nixpkgs { system = "x86_64-linux"; };
            nodeSpecialArgs = builtins.mapAttrs (_: v: v._module.specialArgs) self.nixosConfigurations;
          };
        }
        // builtins.mapAttrs
          (_: v: {
            imports = v._module.args.modules;
            nixpkgs.system = v.config.nixpkgs.system;
          })
          (
            nixpkgs.lib.filterAttrs (
              _: v: (builtins.elem "server" v.config.deployment.tags)
            ) self.nixosConfigurations
          );

      colmenaHive = inputs.colmena.lib.makeHive self.outputs.colmena;

      nixosConfigurations = {
        laptop0 = import ./nixos/laptop0 {
          system = "x86_64-linux";
          inherit self nixpkgs inputs;
        };
        laptop1 = import ./nixos/laptop1 {
          system = "x86_64-linux";
          inherit self nixpkgs inputs;
        };
        lax0 = import ./nixos/lax0 {
          system = "x86_64-linux";
          inherit self nixpkgs inputs;
        };
        nas = import ./nixos/nas {
          system = "x86_64-linux";
          inherit self nixpkgs inputs;
        };
        nrt0 = import ./nixos/nrt0 {
          system = "x86_64-linux";
          inherit self nixpkgs inputs;
        };
        nrt1 = import ./nixos/nrt1 {
          system = "aarch64-linux";
          inherit self nixpkgs inputs;
        };
        nrt2 = import ./nixos/nrt2 {
          system = "aarch64-linux";
          inherit self nixpkgs inputs;
        };
        sha0 = import ./nixos/sha0 {
          system = "x86_64-linux";
          inherit self nixpkgs inputs;
        };
        sxb0 = import ./nixos/sxb0 {
          system = "x86_64-linux";
          inherit self nixpkgs inputs;
        };
      };

      homeModules = import ./modules/home;

      nixosModules = import ./modules/nixos;
    };
}
