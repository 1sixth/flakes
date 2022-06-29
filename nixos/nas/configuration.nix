{ config, pkgs, lib, ... }:

{
  imports = [
    ./campus_login.nix
    ./frpc.nix
    ./hardware.nix
    ./sftp.nix
  ];

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

  networking.hostName = "nas";

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [
        "/persistent/8T"
        "/persistent/16T"
      ];
    };
    fstrim.enable = true;
  };

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
