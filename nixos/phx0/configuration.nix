{ ... }:

{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./miniflux.nix
    ./postgresql.nix
    ./vaultwarden.nix
  ];

  networking.hostName = "phx0";

  sops.defaultSopsFile = ./secrets.yaml;
}
