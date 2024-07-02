{ ... }:

{
  imports = [ ./hardware.nix ];

  boot.kernelParams = [ "mitigations=off" ];

  networking.hostName = "lax0";

  sops.defaultSopsFile = ./secrets.yaml;
}
