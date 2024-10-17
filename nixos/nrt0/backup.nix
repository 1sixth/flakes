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
      paths = builtins.map (x: "/var/lib/" + x) [
        "backup"
        "vaultwarden"
      ];
      pruneOpts = [
        "--keep-hourly 24"
        "--keep-daily 30"
        "--keep-monthly 12"
      ];
      rcloneConfigFile = "/var/lib/rclone.conf";
      repository = "rclone:restic:Restic";
      timerConfig.OnCalendar = "*:05";
    };
  };

  sops.secrets.restic = { };
}
