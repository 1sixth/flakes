{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "tyo2";

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
