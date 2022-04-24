{ config, pkgs, ... }:

{

  nix = {
    buildMachines = [
      {
        hostName = "localhost";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        systems = [
          "aarch64-linux"
          "x86_64-linux"
        ];
      }
      {
        hostName = "tyo0";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-armv8-a" ];
        systems = [
          "aarch64-linux"
          "x86_64-linux"
        ];
      }
    ];
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
  };

  programs.ssh = {
    knownHosts."tyo0.9875321.xyz".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICDgtb4zRBJ5xKMeEwJkhY7H68eUBNvSuBiRuuF0U02j";
    extraConfig = ''
      Host tyo0
        HostName tyo0.9875321.xyz
        IdentityFile ${config.sops.secrets.tyo0_ssh_private_key.path}
        User root
    '';
  };

  services = {
    nginx.virtualHosts."hydra.shinta.ro" = {
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:3000";
      useACMEHost = "shinta.ro";
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
      extraConfig = ''
        binary_cache_secret_key_file = ${config.sops.secrets.secret-key-files.path}
        store_uri = auto?secret-key=${config.sops.secrets.secret-key-files.path}
        <githubstatus>
          jobs = personal:flakes:.*
        </githubstatus>
      '';
      hydraURL = "https://hydra.shinta.ro";
      listenHost = "127.0.0.1";
      notificationSender = "hydra@shinta.ro";
      package = pkgs.hydra;
      useSubstitutes = true;
    };
  };

  nix.settings.secret-key-files = config.sops.secrets.secret-key-files.path;

  sops.secrets = {
    secret-key-files = {
      mode = "0440";
      owner = config.users.users.hydra.name;
      inherit (config.users.users.hydra) group;
    };
    tyo0_ssh_private_key = {
      mode = "0440";
      owner = config.users.users.hydra.name;
      inherit (config.users.users.hydra) group;
    };
  };
}
