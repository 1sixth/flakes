{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    # Unfortunately, ensureDatabases isn't powerful enough.
    # Wait until #203474 is merged.
    package = pkgs.postgresql_14;
    settings = {
      # https://pgtune.leopard.in.ua/
      max_connections = 200;
      shared_buffers = "256MB";
      effective_cache_size = "768MB";
      maintenance_work_mem = "64MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "7864kB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "655kB";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
    };
  };
}