{ config, pkgs, ... }:

{
  services = {
    nginx.virtualHosts = {
      "cache.shinta.ro" = {
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:5000";
        useACMEHost = "shinta.ro";
      };
      "hydra.shinta.ro" = {
        forceSSL = true;
        locations."/".proxyPass = "http://127.0.0.1:3000";
        useACMEHost = "shinta.ro";
      };
    };
    postgresql = {
      package = pkgs.postgresql_14;
      settings = {
        # https://pgtune.leopard.in.ua/
        max_connections = 100;
        shared_buffers = "16GB";
        effective_cache_size = "48GB";
        maintenance_work_mem = "2GB";
        checkpoint_completion_target = 0.9;
        wal_buffers = "16MB";
        default_statistics_target = 100;
        random_page_cost = 1.1;
        effective_io_concurrency = 200;
        work_mem = "20971kB";
        min_wal_size = "1GB";
        max_wal_size = "4GB";
        max_worker_processes = 10;
        max_parallel_workers_per_gather = 4;
        max_parallel_workers = 10;
        max_parallel_maintenance_workers = 4;
      };
    };
    hydra = {
      enable = true;
      hydraURL = "https://hydra.shinta.ro";
      listenHost = "127.0.0.1";
      notificationSender = "hydra@shinta.ro";
      package = pkgs.hydra;
      useSubstitutes = true;
    };
    nix-serve = {
      enable = true;
      secretKeyFile = config.sops.secrets.secret-key-files.path;
    };
  };

  sops.secrets.secret-key-files = { };
}
