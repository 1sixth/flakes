{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "tyo0";

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
