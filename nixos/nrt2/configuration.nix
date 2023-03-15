{ ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "nrt2";

  sops.defaultSopsFile = ./secrets.yaml;
}
