{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./samba.nix
  ];

  environment.systemPackages = with pkgs; [
    aria2
    smartmontools
    yt-dlp
  ];

  networking.hostName = "nas";

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
