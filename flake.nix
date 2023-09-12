{
  description = "somewhat somehow deterministic";

  inputs = {
    berberman = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:berberman/flakes";
    };
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
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
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

  outputs = inputs@{ nixpkgs, self, ... }:
    {
      colmena = {
        meta = {
          nixpkgs = import nixpkgs { system = "x86_64-linux"; };
          nodeNixpkgs = builtins.mapAttrs (_: v: v.pkgs) self.nixosConfigurations;
          nodeSpecialArgs = builtins.mapAttrs (_: v: v._module.specialArgs) self.nixosConfigurations;
        };
      } // builtins.mapAttrs
        (_: v: { imports = v._module.args.modules; })
        (nixpkgs.lib.filterAttrs
          (n: _: !nixpkgs.lib.hasPrefix "laptop" n)
          self.nixosConfigurations);

      nixosConfigurations = {
        ams0 = import ./nixos/ams0 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        laptop0 = import ./nixos/laptop0 { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nas = import ./nixos/nas { system = "x86_64-linux"; inherit self nixpkgs inputs; };
        nrt0 = import ./nixos/nrt0 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
        nrt1 = import ./nixos/nrt1 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
        phx0 = import ./nixos/phx0 { system = "aarch64-linux"; inherit self nixpkgs inputs; };
      };

      nixosModules = import ./modules;
    };
}
