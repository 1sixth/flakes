{ config, pkgs, lib, ... }:

{
  imports = [
    ./campus_login.nix
    ./hardware.nix
    ./frpc.nix
    ./sftp.nix
  ];

  environment = {
    persistence."/persistent/impermanence" = {
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
    systemPackages = with pkgs; [
      gallery-dl
      smartmontools
      yt-dlp
    ];
  };

  networking.hostName = "nas";

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/persistent/8T"
      "/persistent/16T"
    ];
  };

  sops.defaultSopsFile = ./secrets.yaml;

  system.stateVersion = "22.05";
}
