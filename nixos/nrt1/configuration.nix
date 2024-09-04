{ ... }:

{
  imports = [ ./hardware.nix ];

  deployment.buildOnTarget = true;

  networking.hostName = "nrt1";

  services.k3s.enable = true;

  sops.defaultSopsFile = ./secrets.yaml;
}
