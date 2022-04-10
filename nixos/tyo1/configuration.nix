{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "tyo1";

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
