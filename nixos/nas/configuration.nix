{ config, self, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./sftp.nix
  ];

  environment.systemPackages = with pkgs; [
    aria2
    smartmontools
    yt-dlp
  ];

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
