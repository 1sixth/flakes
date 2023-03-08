{ config, ... }:

{
  imports = [
    ./backup.nix
    ./hardware.nix
    ./miniflux.nix
    ./postgresql.nix
    ./vaultwarden.nix
  ];

  environment.persistence."/persistent/impermanence".directories = [
    "/tmp"
  ];

  networking.hostName = "phx0";

  sops.defaultSopsFile = ./secrets.yaml;
}
