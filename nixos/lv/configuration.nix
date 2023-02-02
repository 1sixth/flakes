{ config, ... }:

{
  imports = [ ./hardware.nix ];

  networking.hostName = "lv";

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

  systemd.network.networks.default = {
    address = [ "2605:6400:20:1fef::1/48" ];
    gateway = [ "2605:6400:20::1" ];
  };

  system.stateVersion = "22.05";
}
