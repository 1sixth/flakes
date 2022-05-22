{ config, ... }:

{
  services = {
    postgresqlBackup = {
      compression = "zstd";
      enable = true;
      location = "/var/lib/backup/postgresql";
      startAt = "hourly";
    };
    restic.backups.main = {
      initialize = true;
      passwordFile = config.sops.secrets.restic.path;
      paths = builtins.map (x: "/persistent/impermanence/var/lib/" + x) [
        "backup"
        "qbittorrent-nox"
        "vaultwarden"
      ];
      pruneOpts = [
        "--keep-hourly 24"
        "--keep-daily 30"
        "--keep-monthly 12"
      ];
      rcloneConfigFile = "/persistent/impermanence/var/lib/backup/rclone.conf";
      repository = "rclone:restic:";
      timerConfig.OnCalendar = "*:05";
    };
  };

  sops.secrets.restic = { };
}
