{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "nrt4";

  sops.defaultSopsFile = ./secrets.yaml;
}
