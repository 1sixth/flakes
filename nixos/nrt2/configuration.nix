{ ... }:

{
  imports = [ ./hardware.nix ];

  deployment.tags = [ "earth" ];

  networking.hostName = "nrt2";

  sops.defaultSopsFile = ./secrets.yaml;
}
