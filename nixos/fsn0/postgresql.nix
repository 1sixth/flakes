{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    settings = {
      # https://pgtune.leopard.in.ua/
      max_connections = 200;
      shared_buffers = "1GB";
      effective_cache_size = "3GB";
      maintenance_work_mem = "256MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 300;
      work_mem = "2621kB";
      huge_pages = "off";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
    };
  };
}
