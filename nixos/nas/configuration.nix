{ config, self, pkgs, lib, ... }:

{
  imports = [
    ./hardware.nix
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
      smartmontools
      yt-dlp
    ];
  };

  networking.hostName = "nas";

  nixpkgs.overlays = [ self.overlays.qbittorrent-nox ];

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
