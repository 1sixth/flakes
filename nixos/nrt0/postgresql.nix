{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    settings = {
      # https://pgtune.leopard.in.ua/
      max_connections = 200;
      shared_buffers = "2816MB";
      effective_cache_size = "8448MB";
      maintenance_work_mem = "704MB";
      checkpoint_completion_target = 0.9;
      wal_buffers = "16MB";
      default_statistics_target = 100;
      random_page_cost = 1.1;
      effective_io_concurrency = 200;
      work_mem = "4805kB";
      huge_pages = "off";
      min_wal_size = "1GB";
      max_wal_size = "4GB";
      max_worker_processes = 6;
      max_parallel_workers_per_gather = 3;
      max_parallel_workers = 6;
      max_parallel_maintenance_workers = 3;
    };
  };
}
