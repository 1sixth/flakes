{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./samba.nix
    ./smokeping.nix
  ];

  boot.kernelParams = [ "mitigations=off" ];

  deployment.targetHost = config.networking.hostName;

  environment.systemPackages = with pkgs; [
    aria2
    smartmontools
    yt-dlp
  ];

  networking.hostName = "nas";

  nix.settings.substituters = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
  ];

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = [
        "/persistent/8T"
        "/persistent/16T"
      ];
    };
    iperf3.enable = true;
  };

  sops.defaultSopsFile = ./secrets.yaml;
}
