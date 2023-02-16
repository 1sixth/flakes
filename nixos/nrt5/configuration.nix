{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "nrt5";

  sops.defaultSopsFile = ./secrets.yaml;
}
