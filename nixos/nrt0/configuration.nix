{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "nrt0";

  sops.defaultSopsFile = ./secrets.yaml;
}
