{ config, self, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./sftp.nix
  ];

  environment = {
    persistence."/persistent/impermanence" = {
      directories = [
        "/root"
      ];
      files = [
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

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/persistent/8T"
      "/persistent/16T"
    ];
  };

  sops.defaultSopsFile = ./secrets.yaml;
}
