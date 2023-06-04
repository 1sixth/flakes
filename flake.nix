{
  description = "somewhat somehow deterministic";

  inputs = {
    colmena = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
        stable.follows = "nixpkgs";
      };
      url = "github:zhaofengli/colmena";
    };
    flake-compat = {
      flake = false;
      url = "github:edolstra/flake-compat";
    };
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    sops-nix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs";
      };
      url = "github:Mic92/sops-nix";
    };
  };

  outputs = inputs@{ flake-utils, nixpkgs, self, ... }:

    {
      colmenaHive = inputs.colmena.lib.makeHive (
        {
          meta = {
            nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
            nodeSpecialArgs = builtins.mapAttrs
              (name: value: self.nixosConfigurations.${name}._module.specialArgs)
              self.nixosConfigurations;
          };
        } // builtins.mapAttrs
          (name: value: {
            nixpkgs.system = value.config.nixpkgs.system;
            imports = value._module.args.modules;
          })
          (nixpkgs.lib.filterAttrs (name: value: !nixpkgs.lib.hasSuffix "toy" name) self.nixosConfigurations)
      );

      nixosConfigurations = {
        ams0 = import ./nixos/ams0 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nas = import ./nixos/nas { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        oldtoy = import ./nixos/oldtoy { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nrt0 = import ./nixos/nrt0 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
        nrt1 = import ./nixos/nrt1 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
        phx0 = import ./nixos/phx0 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
        toy = import ./nixos/toy { system = "x86_64-linux"; inherit self nixpkgs inputs; };
      };

      nixosModules = import ./modules;

      overlays = import ./overlays { inherit inputs; };
    } // flake-utils.lib.eachSystem
      (with flake-utils.lib.system; [
        aarch64-linux
        x86_64-linux
      ])
      (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              inputs.colmena.overlays.default
            ];
          };
        in
        {
          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              colmena
              sops
            ];
          };
        }
      );
}
