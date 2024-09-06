{ ... }:

{
  imports = [ ./hardware.nix ];

  deployment.buildOnTarget = true;

  networking.hostName = "nrt1";

  sops.defaultSopsFile = ./secrets.yaml;
}
