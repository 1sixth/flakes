{ config, ... }:

{
  services = {
    prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9090;
      retentionTime = "7d";
      scrapeConfigs = [{
        basic_auth = {
          username = "prometheus";
          password_file = config.sops.secrets.prometheus_basic_auth_password.path;
        };
        job_name = "metrics";
        scheme = "https";
        static_configs = [{
          # TODO: represent this list programmatically
          targets = [
            "fsn0.9875321.xyz"
            "nrt0.9875321.xyz"
            "nrt1.9875321.xyz"
          ];
        }];
      }];
      webExternalUrl = "https://${config.networking.hostName}.9875321.xyz/prometheus";
    };
    traefik.dynamicConfigOptions.http = {
      routers.prometheus = {
        rule = "Host(`${config.networking.hostName}.9875321.xyz`) && PathPrefix(`/prometheus`)";
        service = "prometheus";
      };
      services.prometheus.loadBalancer.servers = [{
        url = "http://127.0.0.1:${builtins.toString config.services.prometheus.port}";
      }];
    };
  };

  sops.secrets.prometheus_basic_auth_password = {
    restartUnits = [ "prometheus.service" ];
    sopsFile = ./secrets.yaml;
    owner = config.systemd.services.prometheus.serviceConfig.User;
  };
}
