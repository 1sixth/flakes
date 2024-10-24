{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./samba.nix
    ./smokeping.nix
  ];

  boot.kernelParams = [ "mitigations=off" ];

  deployment.tags = [ "china" ];

  environment = {
    etc."yt-dlp/config".text = ''
      --download-archive "archive.log"

      --embed-chapters

      --extractor-args "youtube:skip=dash,hls,translated_subs"

      --match-filter "original_url!*=/shorts/"

      --no-continue

      --output "$PWD/%(channel)s/%(upload_date)s %(title)s.%(ext)s"

      --remux-video mkv

      --retry-sleep extractor:5
      --retry-sleep fragment:5
      --retry-sleep http:5

      --sub-langs "en.*,zh.*"

      --write-subs
    '';
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

  systemd = {
    services = {
      rclone = {
        after = [ "yt-dlp.service" ];
        path = [ pkgs.rclone ];
        serviceConfig = {
          ExecStart = "/root/rclone.sh";
          Restart = "on-failure";
          Type = "oneshot";
        };
        unitConfig.StartLimitIntervalSec = "1h";
      };
      yt-dlp = {
        before = [ "rclone.service" ];
        path = [ pkgs.yt-dlp ];
        serviceConfig = {
          ExecStart = "/root/yt-dlp.sh";
          # Failure to download YouTube Premiere yields an exit code of 1.
          SuccessExitStatus = "1";
          Type = "oneshot";
        };
      };
    };
    timers = {
      rclone = {
        timerConfig = {
          Persistent = true;
          OnCalendar = "daily";
          RandomizedDelaySec = "1h";
        };
        wantedBy = [ "timers.target" ];
      };
      yt-dlp = {
        timerConfig = {
          Persistent = true;
          OnCalendar = "daily";
          RandomizedDelaySec = "1h";
        };
        wantedBy = [ "timers.target" ];
      };
    };
  };
}
