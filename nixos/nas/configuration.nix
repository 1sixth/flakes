{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./samba.nix
    ./smokeping.nix
  ];

  boot.kernelParams = [ "mitigations=off" ];

  deployment.tags = [ "china" ];

  environment.systemPackages = with pkgs; [
    smartmontools
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

  systemd = {
    services.sync = {
      path = [ pkgs.rclone ];
      serviceConfig = {
        ExecStart = "/root/sync.sh";
        Type = "oneshot";
      };
    };
    timers.sync = {
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
        RandomizedDelaySec = "1h";
      };
      wantedBy = [ "timers.target" ];
    };
  };
}
