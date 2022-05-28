{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "tyo1";

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

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
