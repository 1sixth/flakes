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
      repository = "sftp:box:Restic";
      timerConfig.OnCalendar = "*:05";
    };
  };

  sops.secrets.restic = { };
}
