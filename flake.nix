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
    impermanence.url = "github:nix-community/impermanence";
    lix-module = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "git+https://git.lix.systems/lix-project/nixos-module";
    };
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

    let
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      forEachSupportedSystem = nixpkgs.lib.genAttrs supportedSystems;
    in

    {
      colmena =
        {
          meta = {
            nixpkgs = import nixpkgs { system = "x86_64-linux"; };
            nodeSpecialArgs = builtins.mapAttrs (_: v: v._module.specialArgs) self.nixosConfigurations;
          };
        }
        // builtins.mapAttrs (_: v: {
          imports = v._module.args.modules;
          nixpkgs.system = v.config.nixpkgs.system;
        }) (nixpkgs.lib.filterAttrs (n: _: !nixpkgs.lib.hasPrefix "laptop" n) self.nixosConfigurations);

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
          system = "aarch64-linux";
          inherit self nixpkgs inputs;
        };
        nrt1 = import ./nixos/nrt1 {
          system = "aarch64-linux";
          inherit self nixpkgs inputs;
        };
        sha0 = import ./nixos/sha0 {
          system = "x86_64-linux";
          inherit self nixpkgs inputs;
        };
      };

      devShells = forEachSupportedSystem (
        system:

        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              inputs.colmena.overlays.default
              inputs.lix-module.overlays.default
            ];
          };
        in

        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              colmena
              sops
            ];
          };
        }
      );

      homeModules = import ./modules/home;

      nixosModules = import ./modules/nixos;
    };
}
