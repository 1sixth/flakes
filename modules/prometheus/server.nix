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
          receivers = [{
            name = "email";
            email_configs = [{
              to = "1sixth@shinta.ro";
            }];
          }];
          route.receiver = "email";
        };
        enable = true;
        extraFlags = [
          "--cluster.advertise-address ${config.services.prometheus.alertmanager.listenAddress}:${builtins.toString config.services.prometheus.alertmanager.port}"
        ];
        listenAddress = "127.0.0.1";
        port = 9093;
      };
      alertmanagers = [{
        static_configs = [{
          targets = [ "127.0.0.1:${builtins.toString config.services.prometheus.alertmanager.port}" ];
        }];
      }];
      enable = true;
      listenAddress = "127.0.0.1";
      port = 9090;
      retentionTime = "7d";
      rules = [
        (builtins.toJSON
          {
            groups = [{
              name = "metrics";
              rules = [
                {
                  alert = "BtrfsDeviceError";
                  annotations.summary =
                    "{{ $labels.instance }} has {{ $value }} btrfs device errors. Good luck.";
                  expr = ''node_btrfs_device_errors_total > 0'';
                }
                {
                  alert = "DiskWillFillin12Hours";
                  annotations.summary =
                    "{{ $labels.mountpoint }} of {{ $labels.instance }} will fill in 12 hours.";
                  expr = ''predict_linear(node_filesystem_avail_bytes{mountpoint=~"/boot|/persistent"}[1h], 12 * 3600) < 0'';
                  for = "5m";
                }
                {
                  alert = "NodeDown";
                  annotations.summary =
                    "{{ $labels.instance }} has been down for more than 5 minutes.";
                  expr = ''up == 0'';
                  for = "5m";
                }
                {
                  alert = "UnitFailed";
                  annotations.summary =
                    "{{ $labels.instance }} has {{ $value }} failed systemd units.";
                  expr = ''node_systemd_unit_state{state="failed"} > 0'';
                }
              ];
            }];
          })
      ];
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

  sops.secrets = {
    alertmanager = {
      restartUnits = [ "alertmanager.service" ];
      sopsFile = ./secrets.yaml;
    };
    prometheus_basic_auth_password = {
      restartUnits = [ "prometheus.service" ];
      sopsFile = ./secrets.yaml;
      owner = config.systemd.services.prometheus.serviceConfig.User;
    };
  };

  systemd.services.alertmanager.serviceConfig.LoadCredential =
    "smtp_password:${config.sops.secrets.alertmanager.path}";
}
