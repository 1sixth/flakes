{ pkgs, ... }:

{
  services = {
    postgresql = {
      enable = true;
      package = pkgs.postgresql_14;
      settings = {
        # https://pgtune.leopard.in.ua/
        max_connections = 100;
        shared_buffers = "8GB";
        effective_cache_size = "24GB";
        maintenance_work_mem = "2GB";
        checkpoint_completion_target = 0.9;
        wal_buffers = "16MB";
        default_statistics_target = 100;
        random_page_cost = 4;
        effective_io_concurrency = 2;
        work_mem = "10485kB";
        min_wal_size = "1GB";
        max_wal_size = "4GB";
        max_worker_processes = 8;
        max_parallel_workers_per_gather = 4;
        max_parallel_workers = 8;
        max_parallel_maintenance_workers = 4;
      };
    };
    postgresqlBackup = {
      compression = "zstd";
      enable = true;
      location = "/var/lib/backup/postgresql";
      startAt = "daily";
    };
  };
}
