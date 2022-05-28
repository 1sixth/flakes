{ config, ... }:

{
  imports = [ ./hardware.nix ];

  environment.persistence."/persistent/impermanence" = {
    directories = [
      "/root"
      "/var/lib"
      "/var/log/journal"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  networking.hostName = "tyo5";

  services.openiscsi = {
    enable = true;
    name = "iqn.2015-02.oracle.boot:uefi";
  };

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
