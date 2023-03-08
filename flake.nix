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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
      url = "github:nix-community/home-manager";
    };
    impermanence.url = "github:nix-community/impermanence";
    nixpkgs.url = "github:NixOS/nixpkgs/c83dc8d0505452818fb2913b0e7d469995b08223";
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
          # toy is my local machine.
          (nixpkgs.lib.filterAttrs (name: value: name != "toy") self.nixosConfigurations)
      );

      nixosConfigurations = {
        nas = import ./nixos/nas { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nrt0 = import ./nixos/nrt0 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
        nrt1 = import ./nixos/nrt1 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nrt2 = import ./nixos/nrt2 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nrt3 = import ./nixos/nrt3 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
        nrt4 = import ./nixos/nrt4 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nrt5 = import ./nixos/nrt5 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        phx0 = import ./nixos/phx0 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
        toy = import ./nixos/toy { system = "x86_64-linux"; inherit self nixpkgs inputs; };
      };

      nixosModules = import ./modules;
    };
}
