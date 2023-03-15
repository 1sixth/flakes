{ ... }:

{
  imports = [ ./hardware.nix ];

  environment.persistence."/persistent/impermanence".directories = [
    "/tmp"
  ];

  networking.hostName = "nrt0";

  sops.defaultSopsFile = ./secrets.yaml;
}
