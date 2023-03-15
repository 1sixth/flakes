{ lib, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "ams0";

  systemd.network.networks.default = {
    address = [
      "5.255.109.113/24"
      "2a04:52c0:114:f62::1/48"
    ];
    DHCP = null;
    gateway = [
      "5.255.109.1"
      "2a04:52c0:114::1"
    ];
  };

  sops.defaultSopsFile = ./secrets.yaml;
}
