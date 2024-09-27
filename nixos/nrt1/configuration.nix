{ ... }:

{
  imports = [ ./hardware.nix ];

  deployment.tags = [ "earth" ];

  networking.hostName = "nrt1";

  sops.defaultSopsFile = ./secrets.yaml;
}
