{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "tyo5";

  services.openiscsi = {
    enable = true;
    name = "iqn.2015-02.oracle.boot:uefi";
  };

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
