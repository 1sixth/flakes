{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "tyo4";

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
