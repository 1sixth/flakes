{ config, lib, ... }:

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
    vaultwarden.backupDir = "/var/lib/backup/vaultwarden/";
  };

  systemd = {
    services.backup-vaultwarden.environment.DATA_FOLDER = lib.mkForce "/var/lib/vaultwarden";
    timers.backup-vaultwarden.timerConfig.OnCalendar = "hourly";
  };

  sops.secrets.restic = { };
}
