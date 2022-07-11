{ config, ... }:

{
  imports = [ ./hardware.nix ];

  boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

  environment.persistence."/persistent/impermanence" = {
    directories = [
      "/root"
      "/tmp"
      "/var/lib"
      "/var/log/journal"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
    ];
  };

  networking.hostName = "tyo3";

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
