{ config, ... }:

{
  imports = [ ./hardware.nix ];

  environment.persistence."/persistent/impermanence".directories = [
    "/tmp"
  ];

  networking.hostName = "phx0";

  sops.defaultSopsFile = ./secrets.yaml;
}
