{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "las0";

  sops.defaultSopsFile = ./secrets.yaml;

  systemd.network.networks.default = {
    address = [ "2605:6400:20:1fef::1/48" ];
    gateway = [ "2605:6400:20::1" ];
  };
}
