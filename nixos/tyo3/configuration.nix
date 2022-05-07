{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "tyo3";

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
