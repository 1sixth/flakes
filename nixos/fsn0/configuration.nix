{ ... }:

{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./libreddit.nix
    ./miniflux.nix
    ./postgresql.nix
    ./vaultwarden.nix
  ];

  networking.hostName = "fsn0";

  nixpkgs.overlays = [
    (final: prev: {
      redlib = prev.redlib.overrideAttrs (old: rec {
        version = "unstable-2024-05-30";

        src = prev.fetchFromGitHub {
          owner = "redlib-org";
          repo = "redlib";
          rev = "8a3ceaf94a31aba60dadf4e4723fd71696c8cabf";
          hash = "sha256-qfFUiok5FEboA/fEueYgCGgXomnVg0onmjvj57dhXIQ=";
        };

        cargoDeps = old.cargoDeps.overrideAttrs (
          prev.lib.const {
            name = "redlib-vendor.tar.gz";
            inherit src;
            outputHash = "sha256-V3P5UPgsrksKQWQ11WRye5/6onDoaIjksR2xIFtB+D8=";
          }
        );
      });
    })
  ];

  sops.defaultSopsFile = ./secrets.yaml;

  systemd.network.networks.default = {
    address = [ "2a01:4f8:c012:ebef::1/64" ];
    gateway = [ "fe80::1" ];
  };
}
