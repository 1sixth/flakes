{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "nrt1";

  sops.defaultSopsFile = ./secrets.yaml;
}
