{ ... }:

{
  imports = [ ./hardware.nix ];

  deployment.tags = [ "earth" ];

  networking.hostName = "nrt0";

  systemd.network.networks.default = {
    address = [
      "45.8.113.137/24"
      "2a12:a304:4:75::a/48"
    ];
    DHCP = null;
    gateway = [
      "45.8.113.1"
      "2a12:a304:4::1"
    ];
  };
}
