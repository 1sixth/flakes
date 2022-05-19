{ config, pkgs, ... }:

{

  nix = {
    buildMachines = [
      {
        hostName = "fsn";
        maxJobs = 8;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        systems = [
          "i686-linux"
          "x86_64-linux"
        ];
      }
      {
        hostName = "tyo0";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-armv8-a" ];
        systems = [
          "aarch64-linux"
        ];
      }
      {
        hostName = "tyo3";
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "gccarch-armv8-a" ];
        systems = [
          "aarch64-linux"
        ];
      }
    ];
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
  };

  services = {
    nginx.virtualHosts."hydra.shinta.ro" = {
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:3000";
      useACMEHost = "shinta.ro";
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
      useSubstitutes = true;
    };
  };

  nix.settings.secret-key-files = config.sops.secrets.secret-key-files.path;

  sops.secrets.secret-key-files = {
    mode = "0440";
    owner = config.users.users.hydra.name;
    inherit (config.users.users.hydra) group;
  };
}
