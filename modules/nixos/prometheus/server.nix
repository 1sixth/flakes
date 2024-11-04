{ config, ... }:

{
  services = {
    prometheus = {
      alertmanager = {
        configuration = {
          global = {
            smtp_from = "alertmanager@shinta.ro";
            smtp_smarthost = "mail.shinta.ro:465";
            smtp_auth_username = "1sixth@shinta.ro";
            smtp_auth_password_file = "/run/credentials/alertmanager.service/smtp_password";
            smtp_require_tls = false;
          };
          receivers = [
            {
              name = "email";
              email_configs = [ { to = "1sixth@shinta.ro"; } ];
            }
          ];
          route.receiver = "email";
        };
        enable = true;
        extraFlags = [
          "--cluster.advertise-address ${config.services.prometheus.alertmanager.listenAddress}:${builtins.toString config.services.prometheus.alertmanager.port}"
        ];
        listenAddress = "127.0.0.1";
        port = 9093;
      };
      alertmanagers = [
        {
          static_configs = [
            { targets = [ "127.0.0.1:${builtins.toString config.services.prometheus.alertmanager.port}" ]; }
          ];
        }
      ];
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9090;
      retentionTime = "30d";
      rules = [
        (builtins.toJSON {
          groups = [
            {
              name = "metrics";
              rules = [
                {
                  alert = "BtrfsDeviceError";
                  expr = ''node_btrfs_device_errors_total > 0'';
                }
                {
                  alert = "Disk90%Full";
                  expr = ''(node_filesystem_avail_bytes{mountpoint=~"/boot|/persistent"}  / node_filesystem_size_bytes{mountpoint=~"/boot|/persistent"}) < 0.1'';
                }
                {
                  alert = "NodeLoad5";
                  expr = ''node_load5 / count(node_cpu_seconds_total{mode="idle"}) without (cpu,mode) > 0.9'';
                  for = "2m";
                }
                {
                  alert = "NodeLoad10";
                  expr = ''node_load10 / count(node_cpu_seconds_total{mode="idle"}) without (cpu,mode) > 0.9'';
                  for = "2m";
                }
                {
                  alert = "NodeLoad15";
                  expr = ''node_load15 / count(node_cpu_seconds_total{mode="idle"}) without (cpu,mode) > 0.9'';
                  for = "2m";
                }
                {
                  alert = "NodeDown";
                  expr = ''up == 0'';
                  for = "5m";
                }
                {
                  alert = "Ram90%Full";
                  expr = ''node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes < 0.1'';
                }
                {
                  alert = "UnitFailed";
                  expr = ''node_systemd_unit_state{state="failed"} > 0'';
                }
              ];
            }
          ];
        })
      ];
      scrapeConfigs = [
        {
          basic_auth = {
            username = "prometheus";
            password_file = config.sops.secrets.prometheus_basic_auth_password.path;
          };
          job_name = "metrics";
          scheme = "https";
          static_configs = [
            {
              # TODO: represent this list programmatically
              targets = [
                "lax0.9875321.xyz"
                "nas.9875321.xyz"
                "nrt0.9875321.xyz"
                "nrt1.9875321.xyz"
                "nrt2.9875321.xyz"
                "sxb0.9875321.xyz"
              ];
            }
          ];
        }
      ];
      webExternalUrl = "https://prom.shinta.ro/";
    };
    traefik.dynamicConfigOptions.http = {
      routers.prometheus = {
        rule = "Host(`prom.shinta.ro`)";
        service = "prometheus";
      };
      services.prometheus.loadBalancer.servers = [
        { url = "http://127.0.0.1:${builtins.toString config.services.prometheus.port}"; }
      ];
    };
  };

  sops.secrets = {
    alertmanager = {
      restartUnits = [ "alertmanager.service" ];
      sopsFile = ./secrets.yaml;
    };
    prometheus_basic_auth_password = {
      owner = config.systemd.services.prometheus.serviceConfig.User;
      restartUnits = [ "prometheus.service" ];
      sopsFile = ./secrets.yaml;
    };
  };

  systemd.services.alertmanager.serviceConfig.LoadCredential = "smtp_password:${config.sops.secrets.alertmanager.path}";
}
