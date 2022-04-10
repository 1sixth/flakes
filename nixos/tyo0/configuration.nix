{ config, ... }:

{
  imports = [ ./hardware.nix ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  networking.hostName = "tyo0";

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
